package com.example.controller;

import com.example.common.Result;
import com.example.entity.Message;
import com.example.service.MessageService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

/**
 * 聊天室消息接口
 **/
@RestController
@RequestMapping("/message")
public class MessageController {

    @Resource
    private MessageService messageService;

    /**
     * 新增消息
     */
    @PostMapping("/add")
    public Result add(@RequestBody Message message) {
        messageService.add(message); // 保存消息到数据库
        return Result.success();
    }

    /**
     * 查询历史消息
     */
    @GetMapping("/history")
    public Result getHistory() {
        List<Message> messages = messageService.getAllMessages(); // 从数据库加载历史消息
        return Result.success(messages);
    }
}