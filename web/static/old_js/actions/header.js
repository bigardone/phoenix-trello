import Constants              from '../constants';
import { push }               from 'react-router-redux';
import { httpGet, httpPost }  from '../utils';
import CurrentBoardActions    from './current_board';

const Actions = {
  showBoards: (show) => {
    return dispatch => {
      dispatch({
        type: Constants.HEADER_SHOW_BOARDS,
        show: show,
      });
    };
  },

  visitBoard: (socket, channel, boardId) => {
    return dispatch => {
      if (channel) {
        dispatch(CurrentBoardActions.leaveChannel(channel));
        dispatch(CurrentBoardActions.connectToChannel(socket, boardId));
      }

      dispatch(push(`/boards/${boardId}`));

      dispatch({
        type: Constants.HEADER_SHOW_BOARDS,
        show: false,
      });
    };
  },
};

export default Actions;
