const userServices = require('../services/user.services');
exports.register = async (req, res) => {
    try {
        const {firstName, lastName, email, password, role} = req.body;
        const result = await userServices.registerUser(firstName, lastName, email, password, role);
        res.status(200).json({
            message: "User registered successfully",
            result
        });
    } catch (error) {
        res.status(500).json({
            message: "Error registering user",
            error
        });
    }
}

exports.login = async (req, res) => {
    try {
        const {email, password} = req.body;
        const result = await userServices.loginUser(email, password);
        const user = await userServices.findUserbyemail(email);
        let token = {user};
        const secretKey = "123";
        const tokenResult = await userServices.generateToken(token, secretKey);
        res.status(200).json({
            message: "User logged in successfully",
            token: tokenResult,
            data: result
        });
    } catch (error) {
        res.status(500).json({
            message: "Error logging in user",
            error
        });
    }
    
}

exports.getUser = (userId) => {
    return userService.getUserById(userId);
  };


exports.updatePassword = async (req, res) => {
    try {
        const {email, password} = req.body;
        const result = await userServices.resetpassword(email, password);
        res.status(200).json({
            message: "Password updated successfully",
            data: result
        });
    } catch (error) {  
        res.status(500).json({
            message: "Error updating password",
            error
        });
    }
}

exports.updateName = async (req, res) => {
    try {
        const {email, firstName, lastName} = req.body;
        const result = await userServices.updateName(email, firstName, lastName);
        res.status(200).json({
            message: "Name updated successfully",
            data: result
        });
    } catch (error) {
        res.status(500).json({
            message: "Error updating name",
            error
        });
    }
}
exports.updatePic = async (req, res) => {
    try {
        const {email} = req.body;
        const {filename} = req.file;
        const result = await userServices.updatePic(email, filename);
        res.status(200).json({
            message: "Image updated successfully",
            data: result
        });
    } catch (error) {
        res.status(500).json({
            message: "Error updating image",
            error
        });
    }
}

exports.updateUser = async (req, res) => {
    try {
        const {email, firstName, lastName, balance} = req.body;
        const result = await userServices.updateUser(email, firstName, lastName, balance);
        res.status(200).json({
            message: "User updated successfully",
            data: result
        });
    } catch (error) {
        res.status(500).json({
            message: "Error updating user",
            error
        });
    }
}