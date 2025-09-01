import { DataTypes, Model, Optional } from "sequelize";
import sequelize from "../config/database";
import ChatRoom from "./ChatRoom";

interface ChatRoomParticipantAttributes {
  id: number;
  userId: number;
}

interface ChatRoomParticipantCreationAttributes extends Optional<ChatRoomParticipantAttributes, 'id' | 'userId'> {}

class ChatRoomParticipant extends Model<ChatRoomParticipantAttributes, ChatRoomParticipantCreationAttributes> implements ChatRoomParticipantAttributes {
  public id!: number;
  public userId!: number;

  public readonly joinedAt!: Date;
}

ChatRoomParticipant.init({
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    field: 'room_id'
  },
  userId: {
    type: DataTypes.INTEGER,
    primaryKey: true
  }
}, {
  sequelize,
  tableName: 'chat_room_participants',
  paranoid: false, // soft-delete 필요 없음
  timestamps: false,
  underscored: true
});

export default ChatRoomParticipant;