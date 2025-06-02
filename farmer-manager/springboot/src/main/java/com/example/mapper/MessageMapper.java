package com.example.mapper;

import com.example.entity.Message;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

@Mapper
public interface MessageMapper {

    /**
     * 新增消息
     */
    void insert(Message message); // 方法签名与 XML 中的 id 对应

    /**
     * 查询所有历史消息
     */
    @Select("SELECT * FROM message ORDER BY time ASC")
    List<Message> getAllMessages();
}