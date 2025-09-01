
import { DataTypes, Model, Optional } from 'sequelize';
import sequelize from '../config/database';

interface FoodAttributes {
  id: number;
  title: string;
  author: string;
  authorId: number;
  description: string;
  imageUrl: string;
  thumbnailUrl: string;
  expirationDate: Date;
  deletedAt: Date | null;
}

interface FoodCreationAttributes extends Optional<FoodAttributes, 'id' | 'deletedAt'> {}

class Food extends Model<FoodAttributes, FoodCreationAttributes> implements FoodAttributes {
  public id!: number;
  public title!: string;
  public author!: string;
  public authorId!: number;
  public description!: string;
  public imageUrl!: string;
  public thumbnailUrl!: string;
  public expirationDate!: Date;
  public deletedAt!: Date | null;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

Food.init({
  id: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true,
    allowNull: false
  },
  title: {
    type: DataTypes.STRING,
    allowNull: false
  },
  author: {
    type: DataTypes.STRING,
    allowNull: false
  },
  authorId: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  imageUrl: {
    type: DataTypes.STRING,
    allowNull: false
  },
  thumbnailUrl: {
    type: DataTypes.STRING,
    allowNull: false
  },
  expirationDate: {
    type: DataTypes.DATE,
    allowNull: false
  },
  deletedAt: {
    type:DataTypes.DATE
  },
}, {
  sequelize,
  tableName: 'foods',
  paranoid: true,
  underscored: true
});

export default Food;
