import { NextFunction, Request, Response } from "express";
import ChatRoom from "../models/ChatRoom";
import ChatRoomParticipant from "../models/ChatRoomParticipant";
import { Sequelize, Op } from "sequelize";
import sequelize from "../config/database";

export const createChat = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const { postId, userId, authorId } = req.body;
    if (!postId || !userId) {
      return res.status(400).json({ message: "게시글 id와 사용자 id 필요" });
    }

    const chatRoom = await ChatRoom.findOne({
      where: {
        postId: postId,
        id: {
          [Op.in]: sequelize.literal(`
                (SELECT crp.room_id FROM chat_room_participants AS crp WHERE crp.user_id IN (${[
                  userId,
                  authorId,
                ].join(
                  ", "
                )}) GROUP BY crp.room_id HAVING count(crp.user_id) = 2)
            `),
        },
      },
    });
    let roomId;
    if (chatRoom) {
      roomId = chatRoom.getDataValue("id");
      console.log("Existing chat room found with ID:", roomId);
    } else {
      // 새로운 채팅방 생성 시 creator_id 추가
      const newChatRoom = await ChatRoom.create({
        postId: postId,
        name: `Chat for Post ${postId}`,
        type: "public",
        creatorId: userId,
      });
      roomId = newChatRoom.getDataValue("id");
      console.log("New chat room created with ID:", roomId);

      // 두 사용자(요청자, 게시글 작성자)를 참여자로 추가
      await ChatRoomParticipant.bulkCreate([
        { id: roomId, userId: userId },
        { id: roomId, userId: authorId },
      ]);
    }

    return res.status(200).json({ roomId: roomId });
  } catch (err) {
    console.log("채팅방 조회 에러", err);
  }
};
