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

  showMembersSelector: (show) => {
    return dispatch => {
      dispatch({
        type: Constants.CURRENT_CARD_SHOW_MEMBERS_SELECTOR,
        show: show,
      });
    };
  },

  addMember: (channel, cardId, userId) => {
    return dispatch => {
      channel.push('card:add_member', { card_id: cardId, user_id: userId });
    };
  },

  removeMember: (channel, cardId, userId) => {
    return dispatch => {
      channel.push('card:remove_member', { card_id: cardId, user_id: userId });
    };
  },
};

export default Actions;
