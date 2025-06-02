package com.example.service;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.google.gson.Gson;
import okhttp3.*;
import org.springframework.stereotype.Service;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class XunfeiAIService extends WebSocketListener {

    private static final String HOST_URL = "https://spark-api.xf-yun.com/v1/x1";
    private static final String DOMAIN = "x1";
    private static final String APPID = "341bf414";
    private static final String API_SECRET = "ZjkzNWU0M2JhOTQxZmIxMGFjNzEwMjNl";
    private static final String API_KEY = "ad5267fa58680ba12df263e78bcbe814";

    private static final Gson gson = new Gson();
    private boolean wsCloseFlag = false;
    private final StringBuilder aiResponse = new StringBuilder();

    public String chatWithAI(String userMessage) throws Exception {
        wsCloseFlag = false; // 重置 WebSocket 关闭标志
        aiResponse.setLength(0); // 清空之前的响应内容
        // 构建鉴权 URL
        String authUrl = getAuthUrl(HOST_URL, API_KEY, API_SECRET);
        OkHttpClient client = new OkHttpClient.Builder().build();
        String url = authUrl.replace("http://", "ws://").replace("https://", "wss://");
        Request request = new Request.Builder().url(url).build();
        WebSocket webSocket = client.newWebSocket(request, this);

        // 启动发送线程
        new Thread(() -> sendMessage(webSocket, userMessage)).start();

        // 等待 WebSocket 关闭
        while (!wsCloseFlag) {
            Thread.sleep(200);
        }

        return aiResponse.length() > 0 ? aiResponse.toString() : "AI 没有返回内容";
    }

    private void sendMessage(WebSocket webSocket, String userMessage) {
        try {
            JSONObject requestJson = new JSONObject();

            // Header 参数
            JSONObject header = new JSONObject();
            header.put("app_id", APPID);
            header.put("uid", UUID.randomUUID().toString().substring(0, 10));

            // Parameter 参数
            JSONObject parameter = new JSONObject();
            JSONObject chat = new JSONObject();
            chat.put("domain", DOMAIN);
            chat.put("temperature", 0.5);
            chat.put("max_tokens", 4096);
            parameter.put("chat", chat);

            // Payload 参数
            JSONObject payload = new JSONObject();
            JSONObject message = new JSONObject();
            JSONArray text = new JSONArray();

            JSONObject roleContent = new JSONObject();
            roleContent.put("role", "user");
            roleContent.put("content", userMessage);
            text.add(roleContent);

            message.put("text", text);
            payload.put("message", message);

            requestJson.put("header", header);
            requestJson.put("parameter", parameter);
            requestJson.put("payload", payload);

            webSocket.send(requestJson.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onOpen(WebSocket webSocket, Response response) {
        System.out.println("WebSocket 连接已打开");
    }

    @Override
    public void onMessage(WebSocket webSocket, String text) {
        System.out.println("收到消息: " + text);

        // 使用 Gson 将 JSON 字符串解析为 Java 对象
        JsonParse myJsonParse = gson.fromJson(text, JsonParse.class);

        // 检查返回的状态码
        if (myJsonParse.header.code != 0) {
            System.out.println("发生错误，错误码为：" + myJsonParse.header.code);
            System.out.println("本次请求的 sid 为：" + myJsonParse.header.sid);
            webSocket.close(1000, "错误发生，关闭连接");
            return;
        }

        // 检查状态是否完成
        if (myJsonParse.header.status == 2) {
            System.out.println("AI 响应完成，关闭连接");
            wsCloseFlag = true; // 标记 WebSocket 可以关闭
        }

        // 提取 AI 的回复内容
        if (myJsonParse.payload != null && myJsonParse.payload.choices != null) {
            for (Text choice : myJsonParse.payload.choices.text) {
                if (choice.content == null || choice.content.isEmpty()) {
                    continue; // 跳过空内容
                }
                System.out.println("AI 回复内容: " + choice.content);
                aiResponse.append(choice.content); // 将内容追加到响应中
            }
        }
    }

    @Override
    public void onFailure(WebSocket webSocket, Throwable t, Response response) {
        System.err.println("WebSocket 连接失败: " + t.getMessage());
        if (response != null) {
            System.err.println("响应码: " + response.code());
        }
    }

    @Override
    public void onClosing(WebSocket webSocket, int code, String reason) {
        System.out.println("WebSocket 连接关闭中: " + reason);
        wsCloseFlag = true;
    }

    @Override
    public void onClosed(WebSocket webSocket, int code, String reason) {
        System.out.println("WebSocket 连接已关闭: " + reason);
    }

    private String getAuthUrl(String hostUrl, String apiKey, String apiSecret) throws Exception {
        URL url = new URL(hostUrl);
        SimpleDateFormat format = new SimpleDateFormat("EEE, dd MMM yyyy HH:mm:ss z", Locale.US);
        format.setTimeZone(TimeZone.getTimeZone("GMT"));
        String date = format.format(new Date());

        String preStr = "host: " + url.getHost() + "\n" + "date: " + date + "\n" + "GET " + url.getPath() + " HTTP/1.1";

        Mac mac = Mac.getInstance("hmacsha256");
        SecretKeySpec spec = new SecretKeySpec(apiSecret.getBytes(StandardCharsets.UTF_8), "hmacsha256");
        mac.init(spec);

        byte[] hexDigits = mac.doFinal(preStr.getBytes(StandardCharsets.UTF_8));
        String sha = Base64.getEncoder().encodeToString(hexDigits);

        String authorization = String.format("api_key=\"%s\", algorithm=\"%s\", headers=\"%s\", signature=\"%s\"",
                apiKey, "hmac-sha256", "host date request-line", sha);

        HttpUrl httpUrl = Objects.requireNonNull(HttpUrl.parse("https://" + url.getHost() + url.getPath())).newBuilder()
                .addQueryParameter("authorization", Base64.getEncoder().encodeToString(authorization.getBytes(StandardCharsets.UTF_8)))
                .addQueryParameter("date", date)
                .addQueryParameter("host", url.getHost())
                .build();

        return httpUrl.toString();
    }

    // JSON 解析类
    static class JsonParse {
        Header header;
        Payload payload;
    }

    static class Header {
        int code;       // 状态码
        int status;     // 状态
        String sid;     // 会话 ID
    }

    static class Payload {
        Choices choices;
    }

    static class Choices {
        List<Text> text; // 回复内容列表
    }

    static class Text {
        String role;    // 角色（如 "assistant" 或 "user"）
        String content; // 回复内容
    }
}