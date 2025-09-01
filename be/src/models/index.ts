import ChatRoom from './ChatRoom';
import ChatRoomParticipant from './ChatRoomParticipant';

// 관계 정의
ChatRoom.hasMany(ChatRoomParticipant, { foreignKey: 'room_id' });
ChatRoomParticipant.belongsTo(ChatRoom, { foreignKey: 'room_id' });

export { ChatRoom, ChatRoomParticipant };