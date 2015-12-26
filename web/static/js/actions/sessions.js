import { pushPath }           from 'redux-simple-router';
import Constants              from '../constants';
import { Socket }             from '../phoenix';
import { httpGet, httpPost }  from '../utils';

const Actions = {};

Actions.fetchCurrenUser = () => {
  const authToken = localStorage.phoenixAuthToken;

  return httpGet(`/api/v1/current_user?jwt=${authToken}`);
};

Actions.setCurrentUser = (dispatch, user) => {
  dispatch({
    type: Constants.CURRENT_USER,
    currentUser: user,
  });

  let socket = new Socket('/socket', {
    params: {token: localStorage.phoenixAuthToken},
    logger: (kind, msg, data) => { console.log(`${kind}: ${msg}`, data); },
  });

  socket.connect();

  dispatch({
    type: Constants.SOCKET_CONNECTED,
    socket: socket,
  });

};

Actions.signIn = (email, password) => {
  return dispatch => {
    const data = {
      session: {
        email: email,
        password: password,
      },
    };

    httpPost('/api/v1/sessions', data)
    .then((data) => {
      localStorage.phoenixAuthToken = data.jwt;
      Actions.setCurrentUser(dispatch, data.user);
      dispatch(pushPath('/'));
    })
    .catch((error) => {
      error.response.json()
      .then((errorJSON) => {
        dispatch({
          type: Constants.SESSIONS_ERROR,
          error: errorJSON.error,
        });
      });
    });
  };
};

Actions.currentUser = () => {
  console.log('Action currentUser');
  return dispatch => {
    Actions.fetchCurrenUser()
    .then(function(data) {
      Actions.setCurrentUser(dispatch, data);
    })
    .catch(function(error) {
      console.log(error);
      dispatch(pushPath('/sign_in'));
    });
  };
};

Actions.signOut = () => {
  return dispatch => {
    localStorage.removeItem('phoenixAuthToken');

    dispatch({
      type: Constants.USER_SIGNED_OUT,
    });

    dispatch(pushPath('/sign_in'));
  };
};

export default Actions;
