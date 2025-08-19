import { DataTypes, Model, Optional } from "sequelize";
import sequelize from "../config/database";

interface ChatRoomAttributes {
  id: number;
  name: string;
  type: string;
  creatorId: number;
  deletedAt: Date | null;
}

interface ChatRoomCreationAttributes extends Optional<ChatRoomAttributes, 'id' | 'deletedAt'> {}

class ChatRoom extends Model<ChatRoomAttributes, ChatRoomCreationAttributes> implements ChatRoomAttributes {
  public id!: number;
  public name!: string;
  public type!: string;
  public creatorId!: number;
  public deletedAt!: Date | null;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

ChatRoom.init({
  id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true
  },
  name: {
    type: DataTypes.STRING(100),
    allowNull: false
  },
  type: {
    type: DataTypes.STRING(20),
    defaultValue: 'public'
  },
  creatorId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  deletedAt: {
    type: DataTypes.DATE
  }
}, {
  sequelize,
  tableName: 'chat_rooms',
  paranoid: true,
  timestamps: true
});

export default ChatRoom;