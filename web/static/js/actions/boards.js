import Constants              from '../constants';
import { pushPath }           from 'redux-simple-router';
import { httpGet, httpPost }  from '../utils';

const Actions = {
  fetchBoards: () => {
    return dispatch => {
      const authToken = localStorage.phoenixAuthToken;

      httpGet(`/api/v1/boards?jwt=${authToken}`)
      .then((data) => {
        dispatch({
          type: Constants.BOARDS_RECEIVED,
          ownedBoards: data.owned_boards,
          invitedBoards: data.invited_boards,
        });
      });
    };
  },

  showForm: (show) => {
    return dispatch => {
      dispatch({
        type: Constants.BOARDS_SHOW_FORM,
        show: show,
      });
    };
  },

  create: (data) => {
    return dispatch => {
      httpPost('/api/v1/boards', {board: data})
      .then((data) => {
        dispatch(pushPath(`/boards/${data.id}`));
      })
      .catch((error) => {
        error.response.json()
        .then((json) => {
          dispatch({
            type: Constants.BOARDS_CREATE_ERROR,
            errors: json.errors,
          });
        });
      });
    };
  },

  reset: () => {
    return dispatch => {
      dispatch({
        type: Constants.BOARDS_RESET,
      });
    };
  },
};

export default Actions;
