import React          from 'react';
import { connect }    from 'react-redux';
import { Link }       from 'react-router';
import ReactGravatar  from 'react-gravatar';
import PageClick      from 'react-page-click';
import { routeActions }       from 'redux-simple-router';

import SessionActions from '../actions/sessions';
import HeaderActions  from '../actions/header';

class Header extends React.Component {
  _handleBoardsClick(e) {
    e.preventDefault();

    const { dispatch } = this.props;
    const { ownedBoards, invitedBoards } = this.props.boards;

    if (ownedBoards.length != 0 || invitedBoards.length != 0) {
      dispatch(HeaderActions.showBoards(true));
    } else {
      dispatch(routeActions.push('/'));
    }
  }

  _renderBoards() {
    const { dispatch, currentBoard, socket, header } = this.props;

    if (!header.showBoards) return false;

    const { ownedBoards, invitedBoards } = this.props.boards;

    const ownedBoardsItems = ownedBoards.map((board) => {
      return this._createBoardItem(dispatch, currentBoard, socket, board);
    });

    const ownedBoardsItemsHeader = ownedBoardsItems.length > 0 ? <header className="title"><i className="fa fa-user"/> Owned boards</header> : null;

    const invitedBoardsItems = invitedBoards.map((board) => {
      return this._createBoardItem(dispatch, currentBoard, socket, board);
    });

    const invitedBoardsItemsHeaders = invitedBoardsItems.length > 0 ? <header className="title"><i className="fa fa-users"/> Other boards</header> : null;

    return (
      <PageClick onClick={::this._hideBoards}>
        <div className="dropdown">
          {ownedBoardsItemsHeader}
          <ul>
            {ownedBoardsItems}
          </ul>
          {invitedBoardsItemsHeaders}
          <ul>
            {invitedBoardsItems}
          </ul>
          <ul className="options">
            <li>
              <Link to="/" onClick={::this._hideBoards}>View all boards</Link>
            </li>
          </ul>
        </div>
      </PageClick>
    );
  }

  _hideBoards() {
    const { dispatch } = this.props;
    dispatch(HeaderActions.showBoards(false));
  }

  _createBoardItem(dispatch, currentBoard, socket, board) {
    const onClick = (e) => {
      e.preventDefault();

      if (currentBoard.id != undefined && currentBoard.id == board.id) {
        dispatch(HeaderActions.showBoards(false));
        return false;
      }

      dispatch(HeaderActions.visitBoard(socket, currentBoard.channel, board.id));
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

    this.props.dispatch(SessionActions.signOut());
  }

  render() {
    return (
      <header className="main-header">
        <nav id="boards_nav">
          <ul>
            <li>
              <a href="#" onClick={::this._handleBoardsClick}><i className="fa fa-columns"/> Boards</a>
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

const mapStateToProps = (state) => ({
  currentUser: state.session.currentUser,
  socket: state.session.socket,
  boards: state.boards,
  currentBoard: state.currentBoard,
  header: state.header,
});

export default connect(mapStateToProps)(Header);
