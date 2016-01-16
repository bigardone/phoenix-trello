import React                from 'react';
import { connect }          from 'react-redux';
import classnames           from 'classnames';

import { setDocumentTitle } from '../../utils';
import Actions              from '../../actions/boards';
import BoardCard            from '../../components/boards/card';
import BoardForm            from '../../components/boards/form';

const mapStateToProps = (state) => (
  state.boards
);

class HomeIndexView extends React.Component {
  componentDidMount() {
    setDocumentTitle('Boards');

    this.props.dispatch(Actions.fetchBoards());
  }

  componentWillUnmount() {
    this.props.dispatch(Actions.reset());
  }

  _renderOwnedBoards() {
    const { fetching } = this.props;

    let content = false;

    const iconClasses = classnames({
      fa: true,
      'fa-user': !fetching,
      'fa-spinner': fetching,
      'fa-spin':    fetching,
    });

    if (!fetching) {
      content = (
        <div className="boards-wrapper">
          {::this._renderBoards(this.props.ownedBoards)}
          {::this._renderAddNewBoard()}
        </div>
      );
    }

    return (
      <section>
        <header>
          <h2><i className={iconClasses} /> My boards</h2>
        </header>
        {content}
      </section>
    );
  }

  _renderBoards(boards) {
    return boards.map((board) => {
      return <BoardCard
                key={board.id}
                dispatch={this.props.dispatch}
                {...board} />;
    });
  }

  _renderAddNewBoard() {
    let { showForm, dispatch, formErrors } = this.props;

    if (!showForm) return this._renderAddButton();

    return (
      <BoardForm
        dispatch={dispatch}
        errors={formErrors}
        onCancelClick={::this._handleCancelClick}/>
    );
  }

  _renderOtherBoards() {
    const { invitedBoards } = this.props;

    if (invitedBoards.length === 0) return false;

    return (
      <section>
        <header>
          <h2><i className="fa fa-users" /> Other boards</h2>
        </header>
        <div className="boards-wrapper">
          {::this._renderBoards(invitedBoards)}
        </div>
      </section>
    );
  }

  _renderAddButton() {
    return (
      <div className="board add-new" onClick={::this._handleAddNewClick}>
        <div className="inner">
          <a>Add new board...</a>
        </div>
      </div>
    );
  }

  _handleAddNewClick() {
    let { dispatch } = this.props;

    dispatch(Actions.showForm(true));
  }

  _handleCancelClick() {
    this.props.dispatch(Actions.showForm(false));
  }

  render() {
    return (
      <div className='view-container boards index'>
        {::this._renderOwnedBoards()}
        {::this._renderOtherBoards()}
      </div>
    );
  }
}

export default connect(mapStateToProps)(HomeIndexView);
