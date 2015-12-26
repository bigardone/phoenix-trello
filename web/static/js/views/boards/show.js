import React, {PropTypes}       from 'react';
import { connect }              from 'react-redux';
import Gravatar                 from 'react-gravatar';
import ReactCSSTransitionGroup  from 'react-addons-css-transition-group';
import Actions                  from '../../actions/current_board';
import Constants                from '../../constants';
import { getParentKey }         from '../../utils';
import ListForm                 from '../../components/lists/form';

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

  _renderConnectedUsers() {
    const users = this.props.currentBoard.connectedUsers.map((user) => {
      return (
        <li key={user.id}>
          <Gravatar email={user.email} />
        </li>
      );
    });

    return (
      <ul className="connected-users">
        <ReactCSSTransitionGroup transitionName="avatar" transitionAppear={true} transitionAppearTimeout={500} transitionEnterTimeout={500} transitionLeaveTimeout={300}>
          {users}
        </ReactCSSTransitionGroup>
      </ul>
    );
  }

  _renderLists() {
    const {lists} = this.props.currentBoard;

    return lists.map((list) => {
      return (
        <div key={list.id} className="list">
          <div className="inner">
            <header>
              <h4>{list.name}</h4>
            </header>
            <div className="cards-wrapper">

            </div>
          </div>
        </div>
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
          {::this._renderConnectedUsers()}
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
