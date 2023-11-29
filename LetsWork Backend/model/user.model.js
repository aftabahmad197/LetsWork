const mongoose = require('mongoose');
const db = require('../config/db');
const bcrypt = require('bcrypt');

const {Schema} = mongoose;

const userSchema = new Schema({
    firstName: {
        type: String,
        required: true,
    },
    lastName: {
        type: String,
        required: true,
    },
    email: {
        type: String,
        lowercase: true,
        required: true,
        unique:true,
    },
    password: {
        type: String,
        required: true,
    },
    role: {
        type: String,
        required: true,
        default: "Buyer",
        enum: ["Buyer", "Seller"],
      },
      balance: {
        type: Number,
        default: 0
      },
      profilePic: {
        type: String,
      }
    },
      {
        timestamps: true,
      }
);

userSchema.pre('save', async function (next) {
    try {
        if (this.isModified('password')) {
            const salt = await bcrypt.genSalt(10);
            const hashedPassword = await bcrypt.hash(this.password, salt);
            this.password = hashedPassword;
        }
        next();
    } catch (error) {
        next(error);
    }
});

userSchema.methods.isValidPassword = async function (password) {
    try {
        return await bcrypt.compare(password, this.password);
    } catch (error) {
        throw error;
    }
}

const userModel = mongoose.model('user', userSchema);

module.exports = userModel;
