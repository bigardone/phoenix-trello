import React, {PropTypes}       from 'react';
import { connect }              from 'react-redux';
import Actions                  from '../../actions/current_board';
import Constants                from '../../constants';
import { getParentKey }         from '../../utils';
import ListForm                 from '../../components/lists/form';
import ListCard                 from '../../components/lists/card';
import BoardUsers               from '../../components/boards/users';

class BoardsShowView extends React.Component {
  componentDidMount(nextProps, nextState) {
    const { socket } = this.props;

    if (!socket) {
      return false;
    }

    this.props.dispatch(Actions.connectToChannel(socket, this.props.params.id));
  }

  componentWillUpdate(nextProps, nextState) {
    const { socket } = this.props;

    if (socket) {
      return false;
    }

    this.props.dispatch(Actions.connectToChannel(nextProps.socket, this.props.params.id));
  }

  componentWillUnmount() {
    this.props.dispatch(Actions.leaveChannel(this.props.currentBoard.channel));
  }

  _renderUsers() {
    const {connectedUsers} = this.props.currentBoard;
    const users = [this.props.currentBoard.user, ...this.props.currentBoard.invited_users];

    return (
      <BoardUsers
        users={users}
        connectedUsers={connectedUsers} />
    );
  }

  _renderLists() {
    const {lists, channel} = this.props.currentBoard;

    return lists.map((list) => {
      return (
        <ListCard
          key={list.id}
          dispatch={this.props.dispatch}
          channel={channel}
          {...list} />
      );
    });
  }

  _renderAddNewList() {
    let { dispatch, formErrors, boardsFetched, currentBoard } = this.props;

    if (!currentBoard.showForm) return this._renderAddButton();

    return (
      <ListForm
        dispatch={dispatch}
        errors={formErrors}
        channel={currentBoard.channel}
        onCancelClick={::this._handleCancelClick} />
    );
  }

  _renderAddButton() {
    return (
      <div className="list add-new" onClick={::this._handleAddNewClick}>
        <div className="inner">
          Add new list...
        </div>
      </div>
    );
  }

  _handleAddNewClick() {
    let {showForm, dispatch, boardsFetched} = this.props;

    if (showForm && boardsFetched) return false;

    dispatch(Actions.showForm(true));
  }

  _handleCancelClick() {
    this.props.dispatch(Actions.showForm(false));
  }

  render() {
    const { id, name, currentKey, translations, leaf } = this.props.currentBoard;

    if (!id) return false;

    return (
      <div className='view-container boards show'>
        <header className="view-header">
          <h3>{name}</h3>
          {::this._renderUsers()}
        </header>
        <div className="lists-wrapper">
          {::this._renderLists()}
          {::this._renderAddNewList()}
        </div>
      </div>
    );
  }
}

const mapStateToProps = (state) => ({
  currentBoard: state.currentBoard,
  socket: state.session.socket,
});

export default connect(mapStateToProps)(BoardsShowView);
