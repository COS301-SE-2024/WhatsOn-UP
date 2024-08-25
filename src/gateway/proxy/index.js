const jwt = require('jsonwebtoken');
const axios = require('axios');

exports.modifyHeadersAndForward = async (req, res) => {
  try {
    let authHeader = req.headers.authorization || '';
    if (authHeader.startsWith('Bearer ')) {
      const token = authHeader.split(' ')[1];
      const decoded = jwt.decode(token);
      const userId = decoded?.sub;

      if (userId) {
        req.headers.authorization = userId;
      }
    }

    const backendUrl = `https://api-237rzrxg6a-uc.a.run.app${req.path}`;

    const response = await axios({
      method: req.method,
      url: backendUrl,
      headers: req.headers,
      params: req.query,
      data: req.body,
      validateStatus: (status) => true,
    });

    res.status(response.status).set(response.headers).send(response.data);
  } catch (error) {
    console.error('Error processing the request:', error);
    res.status(500).send('Internal Server Error');
  }
};



