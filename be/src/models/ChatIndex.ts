import sequelize from "../config/database";
import User from "./User";
import ChatRoom from "./ChatRoom";
import Message from "./Message";
import ChatRoomParticipant from "./ChatRoomParticipant";

// 관계 설정
// User:Message (일대다)
User.hasMany(Message, { foreignKey: 'senderId' });
Message.belongsTo(User, { foreignKey: 'senderId' });

// ChatRoom:Message (일대다)
ChatRoom.hasMany(Message, { foreignKey: 'roomId' });
Message.belongsTo(ChatRoom, { foreignKey: 'roomId' });

// User:ChatRoom (다대다)
User.belongsToMany(ChatRoom, { through: ChatRoomParticipant, foreignKey: 'userId' });
ChatRoom.belongsToMany(User, { through: ChatRoomParticipant, foreignKey: 'roomId' });

// 모델 내보내기
export { sequelize, User, ChatRoom, Message, ChatRoomParticipant };