import { DataTypes, Model, Optional } from "sequelize";
import sequelize from "../config/database";

interface MessageAttributes {
  id: number;
  roomId: number;
  senderId: number;
  content: string;
  type: string;
  deletedAt: Date | null;
}

interface MessageCreationAttributes extends Optional<MessageAttributes, 'id' | 'deletedAt'> {}

class Message extends Model<MessageAttributes, MessageCreationAttributes> implements MessageAttributes {
  public id!: number;
  public roomId!: number;
  public senderId!: number;
  public content!: string;
  public type!: string;
  public deletedAt!: Date | null;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

Message.init({
  id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true
  },
  roomId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  senderId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  content: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  type: {
    type: DataTypes.STRING(20),
    defaultValue: 'text'
  },
  deletedAt: {
    type: DataTypes.DATE
  }
}, {
  sequelize,
  tableName: 'messages',
  paranoid: true,
  timestamps: true
});

export default Message;