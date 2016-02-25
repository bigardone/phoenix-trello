import Constants  from '../constants';

const Actions = {
  showForm: (show) => {
    return dispatch => {
      dispatch({
        type: Constants.CURRENT_BOARD_SHOW_FORM,
        show: show,
      });
    };
  },

  connectToChannel: (socket, boardId) => {
    return dispatch => {
      const channel = socket.channel(`boards:${boardId}`);

      dispatch({ type: Constants.CURRENT_BOARD_FETHING });

      channel.join().receive('ok', (response) => {
        dispatch({
          type: Constants.BOARDS_SET_CURRENT_BOARD,
          board: response.board,
        });
      });

      channel.on('user:joined', (msg) => {
        dispatch({
          type: Constants.CURRENT_BOARD_CONNECTED_USERS,
          users: msg.users,
        });
      });

      channel.on('user:left', (msg) => {
        dispatch({
          type: Constants.CURRENT_BOARD_CONNECTED_USERS,
          users: msg.users,
        });
      });

      channel.on('list:created', (msg) => {
        dispatch({
          type: Constants.CURRENT_BOARD_LIST_CREATED,
          list: msg.list,
        });
      });

      channel.on('card:created', (msg) => {
        dispatch({
          type: Constants.CURRENT_BOARD_CARD_CREATED,
          card: msg.card,
        });
      });

      channel.on('member:added', (msg) => {
        dispatch({
          type: Constants.CURRENT_BOARD_MEMBER_ADDED,
          user: msg.user,
        });
      });

      channel.on('card:updated', (msg) => {
        dispatch({
          type: Constants.BOARDS_SET_CURRENT_BOARD,
          board: msg.board,
        });

        dispatch({
          type: Constants.CURRENT_CARD_SET,
          card: msg.card,
        });
      });

      channel.on('list:updated', (msg) => {
        dispatch({
          type: Constants.BOARDS_SET_CURRENT_BOARD,
          board: msg.board,
        });
      });

      channel.on('comment:created', (msg) => {
        dispatch({
          type: Constants.BOARDS_SET_CURRENT_BOARD,
          board: msg.board,
        });

        dispatch({
          type: Constants.CURRENT_CARD_SET,
          card: msg.card,
        });
      });

      dispatch({
        type: Constants.CURRENT_BOARD_CONNECTED_TO_CHANNEL,
        channel: channel,
      });
    };
  },

  leaveChannel: (channel) => {
    return dispatch => {
      channel.leave();

      dispatch({
        type: Constants.CURRENT_BOARD_RESET,
      });
    };
  },

  addNewMember: (channel, email) => {
    return dispatch => {
      channel.push('members:add', { email: email })
      .receive('error', (data) => {
        dispatch({
          type: Constants.CURRENT_BOARD_ADD_MEMBER_ERROR,
          error: data.error,
        });
      });
    };
  },

  updateCard: (channel, card) => {
    return dispatch => {
      channel.push('card:update', { card: card });
    };
  },

  updateList: (channel, list) => {
    return dispatch => {
      channel.push('list:update', { list: list });
    };
  },

  showMembersForm: (show) => {
    return dispatch => {
      dispatch({
        type: Constants.CURRENT_BOARD_SHOW_MEMBERS_FORM,
        show: show,
      });
    };
  },

  editList: (listId) => {
    return dispatch => {
      dispatch({
        type: Constants.CURRENT_BOARD_EDIT_LIST,
        listId: listId,
      });
    };
  },

  showCardForm: (listId) => {
    return dispatch => {
      dispatch({
        type: Constants.CURRENT_BOARD_SHOW_CARD_FORM_FOR_LIST,
        listId: listId,
      });
    };
  },
};

export default Actions;
