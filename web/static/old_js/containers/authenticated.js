import React            from 'react';
import { connect }      from 'react-redux';
import BoardsActions    from '../actions/boards';
import Header           from '../layouts/header';

class AuthenticatedContainer extends React.Component {
  componentDidMount() {
    const { dispatch } = this.props;
    dispatch(BoardsActions.fetchBoards());
  }

  render() {
    const { currentUser, dispatch, boards, socket, currentBoard } = this.props;

    if (!currentUser) return false;

    return (
      <div id="authentication_container" className="application-container">
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
