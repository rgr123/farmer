package com.example.controller;

import com.example.common.Result;
import com.example.service.XunfeiAIService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/ai")
public class AIChatController {

    @Autowired
    private XunfeiAIService aiService;

    @PostMapping("/chat")
    public Result chat(@RequestBody Map<String, String> request) {
        String userMessage = request.get("message");
        // Result.error(userMessage, userMessage)
        try {
            return Result.success(aiService.chatWithAI(userMessage));
        }
        catch (Exception e) {
            // 处理异常并返回错误信息
            return Result.error("200", "AI服务异常: " + e.getMessage());
        }
        // return aiService.chatWithAI(userMessage);
        // return "";
    }
    // public String chat(@RequestBody Map<String, String> request) {
    //     String userMessage = request.get("message");
    //     return aiService.chatWithAI(userMessage);
    //     // return "";
    // }
}
