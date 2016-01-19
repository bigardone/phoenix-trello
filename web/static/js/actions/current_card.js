import Constants  from '../constants';
import {httpGet} from '../utils';

const Actions = {
  showCard: (boardId, cardId) => {
    return dispatch => {
      httpGet(`/api/v1/boards/${boardId}/cards/${cardId}`)
      .then((data) => {
        dispatch({
          type: Constants.CURRENT_CARD_SET,
          card: data,
        });
      });
    };
  },

  editCard: (edit) => {
    return dispatch => {
      dispatch({
        type: Constants.CURRENT_CARD_EDIT,
        edit: edit,
      });
    };
  },

  createCardComment: (channel, comment) => {
    return dispatch => {
      channel.push('card:add_comment', comment);
    };
  },

  reset: (channel, comment) => {
    return dispatch => {
      dispatch({
        type: Constants.CURRENT_CARD_RESET,
      });
    };
  },
};

export default Actions;
