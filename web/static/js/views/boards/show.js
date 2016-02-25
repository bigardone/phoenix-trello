import React, {PropTypes}   from 'react';
import { connect }          from 'react-redux';
import {DragDropContext}    from 'react-dnd';
import HTML5Backend         from 'react-dnd-html5-backend';

import Actions              from '../../actions/current_board';
import Constants            from '../../constants';
import { setDocumentTitle } from '../../utils';
import ListForm             from '../../components/lists/form';
import ListCard             from '../../components/lists/card';
import BoardMembers           from '../../components/boards/members';

@DragDropContext(HTML5Backend)

class BoardsShowView extends React.Component {
  componentDidMount() {
    const { socket } = this.props;

    if (!socket) {
      return false;
    }

    this.props.dispatch(Actions.connectToChannel(socket, this.props.params.id));
  }

  componentWillUpdate(nextProps, nextState) {
    const { socket } = this.props;
    const { currentBoard } = nextProps;

    if (currentBoard.name !== undefined) setDocumentTitle(currentBoard.name);

    if (socket) {
      return false;
    }

    this.props.dispatch(Actions.connectToChannel(nextProps.socket, this.props.params.id));
  }

  componentWillUnmount() {
    this.props.dispatch(Actions.leaveChannel(this.props.currentBoard.channel));
  }

  _renderMembers() {
    const { connectedUsers, showUsersForm, channel, error } = this.props.currentBoard;
    const { dispatch } = this.props;
    const members = this.props.currentBoard.members;
    const currentUserIsOwner = this.props.currentBoard.user.id === this.props.currentUser.id;

    return (
      <BoardMembers
        dispatch={dispatch}
        channel={channel}
        currentUserIsOwner={currentUserIsOwner}
        members={members}
        connectedUsers={connectedUsers}
        error={error}
        show={showUsersForm} />
    );
  }

  _renderLists() {
    const { lists, channel, editingListId, id, addingNewCardInListId } = this.props.currentBoard;

    return lists.map((list) => {
      return (
        <ListCard
          key={list.id}
          boardId={id}
          dispatch={this.props.dispatch}
          channel={channel}
          isEditing={editingListId === list.id}
          onDropCard={::this._handleDropCard}
          onDropCardWhenEmpty={::this._handleDropCardWhenEmpty}
          onDrop={::this._handleDropList}
          isAddingNewCard={addingNewCardInListId === list.id}
          {...list} />
      );
    });
  }

  _renderAddNewList() {
    const { dispatch, formErrors, currentBoard } = this.props;

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
    const { dispatch } = this.props;

    dispatch(Actions.showForm(true));
  }

  _handleCancelClick() {
    this.props.dispatch(Actions.showForm(false));
  }

  _handleDropCard({ source, target }) {
    const { lists, channel } = this.props.currentBoard;
    const { dispatch } = this.props;

    const sourceListIndex = lists.findIndex((list) => { return list.id === source.list_id; });
    const sourceList = lists[sourceListIndex];
    const sourceCardIndex = sourceList.cards.findIndex((card) => { return card.id === source.id; });
    const sourceCard = sourceList.cards[sourceCardIndex];

    const targetListIndex = lists.findIndex((list) => { return list.id === target.list_id; });
    let targetList = lists[targetListIndex];
    const targetCardIndex = targetList.cards.findIndex((card) => { return card.id === target.id; });
    const targetCard = targetList.cards[targetCardIndex];

    sourceList.cards.splice(sourceCardIndex, 1);

    if (sourceList === targetList) {
      // move at once to avoid complications
      targetList = sourceList;
      sourceList.cards.splice(targetCardIndex, 0, source);
    } else {
      // and move it to target
      targetList.cards.splice(targetCardIndex, 0, source);
    }

    const newIndex = targetList.cards.findIndex((card) => { return card.id === source.id; });

    const position = newIndex == 0 ? targetList.cards[newIndex + 1].position / 2 : newIndex == (targetList.cards.length - 1) ? targetList.cards[newIndex - 1].position + 1024 : (targetList.cards[newIndex - 1].position + targetList.cards[newIndex + 1].position) / 2;

    const data = {
      id: sourceCard.id,
      list_id: targetList.id,
      position: position,
    };

    dispatch(Actions.updateCard(channel, data));
  }

  _handleDropList({ source, target }) {
    const { lists, channel } = this.props.currentBoard;
    const { dispatch } = this.props;

    const sourceListIndex = lists.findIndex((list) => { return list.id === source.id; });
    const sourceList = lists[sourceListIndex];
    lists.splice(sourceListIndex, 1);

    const targetListIndex = lists.findIndex((list) => { return list.id === target.id; });
    const targetList = lists[targetListIndex];
    lists.splice(targetListIndex, 0, sourceList);

    const newIndex = lists.findIndex((list) => { return list.id === source.id; });

    const position = newIndex == 0 ? lists[newIndex + 1].position / 2 : newIndex == (lists.length - 1) ? lists[newIndex - 1].position + 1024 : (lists[newIndex - 1].position + lists[newIndex + 1].position) / 2;

    const data = {
      id: source.id,
      position: position,
    };

    dispatch(Actions.updateList(channel, data));
  }

  _handleDropCardWhenEmpty(card) {
    const { channel } = this.props.currentBoard;
    const { dispatch } = this.props;

    dispatch(Actions.updateCard(channel, card));
  }

  render() {
    const { fetching, name } = this.props.currentBoard;

    if (fetching) return (
      <div className="view-container boards show">
        <i className="fa fa-spinner fa-spin"/>
      </div>
    );

    return (
      <div className="view-container boards show">
        <header className="view-header">
          <h3>{name}</h3>
          {::this._renderMembers()}
        </header>
        <div className="canvas-wrapper">
          <div className="canvas">
            <div className="lists-wrapper">
              {::this._renderLists()}
              {::this._renderAddNewList()}
            </div>
          </div>
        </div>
        {this.props.children}
      </div>
    );
  }
}

const mapStateToProps = (state) => ({
  currentBoard: state.currentBoard,
  socket: state.session.socket,
  currentUser: state.session.currentUser,
});

export default connect(mapStateToProps)(BoardsShowView);
