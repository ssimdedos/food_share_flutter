import { DataType, DataTypes, Model, Optional } from "sequelize";
import sequelize from "../config/database";

interface UserAttributes {
  id: number;
  email: string;
  passwordHash: string;
  emailVerified: Boolean;
  userName: string;
  deletedAt: Date | null;  
}

interface UserCreationAttributes extends Optional<UserAttributes, 'id' | 'deletedAt'> {}

class User extends Model<UserAttributes, UserCreationAttributes> implements UserAttributes {
  public id!: number;
  public email!: string;
  public passwordHash!: string;
  public emailVerified!: Boolean;
  public userName!: string;
  public deletedAt!: Date | null;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

User.init({
  id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true
  }, 
  email: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  passwordHash: {
    type: DataTypes.STRING
  },
  emailVerified: {
    type: DataTypes.BOOLEAN
  },
  userName: {
    type: DataTypes.STRING
  },
  deletedAt: {
    type: DataTypes.DATE
  }
}, {
  sequelize,
  tableName:'users',
  paranoid:true
});

export default User;