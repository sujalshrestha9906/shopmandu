const jwt = require('jsonwebtoken');
module.exports.checkAuth = async (req, res, next) => {



  try {
    const token = req.headers.authorization;
    if (!token) {
      res.send.staus(401).json({ message: 'You are not authorized' });
    }


    const decodedToken = jwt.verify(token, process.env.SECRET_KEY);
    if (!decodedToken) {
      res.status(401).json({ message: 'You are not authorized' });
    }
    req.userData = { userId: decodedToken.userId };
    next();

  } catch (err) {
    res.status(401).json({ message: 'You are not authorized' });

  }

}