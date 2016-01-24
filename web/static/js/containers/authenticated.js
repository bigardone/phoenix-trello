import React        from 'react';
import { connect }  from 'react-redux';
import Actions      from '../actions/sessions';
import BoardsActions      from '../actions/boards';
import { routeActions } from 'redux-simple-router';

import Header       from '../layouts/header';

class AuthenticatedContainer extends React.Component {
  componentDidMount() {
    const { dispatch, currentUser } = this.props;

    if (localStorage.getItem('phoenixAuthToken')) {
      if (!currentUser) dispatch(Actions.currentUser());
      dispatch(BoardsActions.fetchBoards());
    } else if (!localStorage.getItem('phoenixAuthToken')) {
      dispatch(routeActions.push('/sign_in'));
    }
  }

  render() {
    const { currentUser, dispatch, boards, socket, currentBoard } = this.props;

    if (!currentUser) return false;

    return (
      <div className="application-container">
        <Header/>

        <div className='main-container'>
          {this.props.children}
        </div>
      </div>
    );
  }
}

const mapStateToProps = (state) => ({
  currentUser: state.session.currentUser,
  socket: state.session.socket,
  channel: state.session.channel,
  boards: state.boards,
  currentBoard: state.currentBoard,
});

export default connect(mapStateToProps)(AuthenticatedContainer);
