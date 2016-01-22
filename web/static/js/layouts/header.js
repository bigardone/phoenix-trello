import React          from 'react';
import { Link }       from 'react-router';
import Actions        from '../actions/sessions';
import BoardsActions  from '../actions/boards';
import ReactGravatar  from 'react-gravatar';

export default class Header extends React.Component {
  constructor() {
    super();
  }

  _renderBoards() {
    const { ownedBoards, invitedBoards } = this.props.boards;
    const { dispatch, currentBoard, socket } = this.props;

    const ownedBoardsItems = ownedBoards.map((board) => {
      return this._createBoardItem(dispatch, currentBoard, socket, board);
    });

    const invitedBoardsItems = invitedBoards.map((board) => {
      return this._createBoardItem(dispatch, currentBoard, socket, board);
    });

    return (
      <ul>
        <li>Owned boards</li>
        {ownedBoardsItems}
        <li>Other boards</li>
        {invitedBoardsItems}
      </ul>
    );
  }

  _createBoardItem(dispatch, currentBoard, socket, board) {
    const onClick = (e) => {
      e.preventDefault();

      if (currentBoard.id != undefined && currentBoard.id == board.id) return false;

      dispatch(BoardsActions.resetCurrentAndReconnect(socket, currentBoard.channel, board.id));
    };

    return (
      <li key={board.id}>
        <a href="#" onClick={onClick}>{board.name}</a>
      </li>
    );
  }

  _renderCurrentUser() {
    const { currentUser } = this.props;

    if (!currentUser) {
      return false;
    }

    const fullName = [currentUser.first_name, currentUser.last_name].join(' ');

    return (
      <a className="current-user">
        <ReactGravatar className="react-gravatar" email={currentUser.email} https /> {fullName}
      </a>
    );
  }

  _renderSignOutLink() {
    if (!this.props.currentUser) {
      return false;
    }

    return (
      <a href="#" onClick={::this._handleSignOutClick}><i className="fa fa-sign-out"/> Sign out</a>
    );
  }

  _handleSignOutClick(e) {
    e.preventDefault();

    this.props.dispatch(Actions.signOut());
  }

  render() {
    return (
      <header className="main-header">
        <nav>
          <ul>
            <li>
              <Link to="/"><i className="fa fa-columns"/> Boards</Link>
              {::this._renderBoards()}
            </li>
          </ul>
        </nav>
        <Link to='/'>
          <span className='logo'/>
        </Link>
        <nav className="right">
          <ul>
            <li>
              {this._renderCurrentUser()}
            </li>
            <li>
              {this._renderSignOutLink()}
            </li>
          </ul>
        </nav>
      </header>
    );
  }
}
