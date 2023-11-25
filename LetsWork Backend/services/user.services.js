const userModel = require('../model/user.model');
const jwt = require('jsonwebtoken');
class userServices {
    static async registerUser(firstName, lastName, email, password, role) {
        try {
            const user = new userModel({
                firstName,
                lastName,
                email,
                password,
                role
            });
            const result = await user.save();
            return result;
        } catch (error) {
            throw error;
        }
    }
    static async loginUser(email, password) {
        try {
            const user = await userModel.findOne({
                email
            });
            if (!user) throw new Error("User does not exist");
            const isValid = await user.isValidPassword(password);
            if (!isValid) throw new Error("Invalid password");
            return user;
        }
        catch (error) {
            throw error;
        }
    }

    static async generateToken(token, secretKey) {
        try {
            const result = await jwt.sign(token, secretKey , { expiresIn: '1h' });
            return result;
        } catch (error) {
            throw error;
        }
    }

    static async findUserbyemail(email) {
        try {
            const user = await userModel.findOne({
                email
            });
            if (!user) throw new Error("User does not exist");
            return user;
        }
        catch (error) {
            throw error;
        }
    }
    static async resetpassword(email, password) {
        try {
            const user = await userModel.findOne({
                email
            });
            if (!user) throw new Error("User does not exist");
            user.password = password;
            const result = await user.save();
            return result;
        }
        catch (error) {
            throw error;
        }
    }
    static async updateName(email, firstName, lastName) {
        try {
            const user = await userModel.findOne({
                email
            });
            if (!user) throw new Error("User does not exist");
            user.firstName = firstName;
            user.lastName = lastName;
            const result = await user.save();
            return result;
        }
        catch (error) {
            throw error;
        }
    }

    static async updatePic(email, profilePic) {
        try {
            const user = await userModel.findOne({
                email
            });
            if (!user) throw new Error("User does not exist");
            user.profilePic = profilePic;
            const result = await user.save();
            return result;
        }
        catch (error) {
            throw error;
        }
    }

    static async updateUser(email, firstName, lastName, balance) {
        try {
            const user = await userModel.findOne({
                email
            });
            if (!user) throw new Error("User does not exist");
            user.firstName = firstName;
            user.lastName = lastName;
            user.balance = balance;
            const result = await user.save();
            return result;
        }
        catch (error) {
            throw error;
        }
    }

}



module.exports = userServices;