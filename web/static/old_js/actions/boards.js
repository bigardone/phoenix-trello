import Constants              from '../constants';
import { push }               from 'react-router-redux';
import { httpGet, httpPost }  from '../utils';
import CurrentBoardActions    from './current_board';

const Actions = {
  fetchBoards: () => {
    return dispatch => {
      dispatch({ type: Constants.BOARDS_FETCHING });

      httpGet('/api/v1/boards')
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
      httpPost('/api/v1/boards', { board: data })
      .then((data) => {
        dispatch({
          type: Constants.BOARDS_NEW_BOARD_CREATED,
          board: data,
        });

        dispatch(push(`/boards/${data.id}`));
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
