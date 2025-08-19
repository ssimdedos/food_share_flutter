import { DataTypes, Model, Optional } from "sequelize";
import sequelize from "../config/database";

interface ChatRoomParticipantAttributes {
  roomId: number;
  userId: number;
}

interface ChatRoomParticipantCreationAttributes extends Optional<ChatRoomParticipantAttributes, 'roomId' | 'userId'> {}

class ChatRoomParticipant extends Model<ChatRoomParticipantAttributes, ChatRoomParticipantCreationAttributes> implements ChatRoomParticipantAttributes {
  public roomId!: number;
  public userId!: number;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

ChatRoomParticipant.init({
  roomId: {
    type: DataTypes.INTEGER,
    primaryKey: true
  },
  userId: {
    type: DataTypes.INTEGER,
    primaryKey: true
  }
}, {
  sequelize,
  tableName: 'chat_room_participants',
  timestamps: true,
  paranoid: false // soft-delete 필요 없음
});

export default ChatRoomParticipant;