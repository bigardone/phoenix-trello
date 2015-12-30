import React        from 'react';
import { connect }  from 'react-redux';
import Actions      from '../../actions/boards';

import BoardCard  from '../../components/boards/card';
import BoardForm  from '../../components/boards/form';

const mapStateToProps = (state) => (
  state.boards
);

class HomeIndexView extends React.Component {
  componentDidMount() {
    this.props.dispatch(Actions.fetchBoards());
  }

  componentWillUnmount() {
    this.props.dispatch(Actions.reset());
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
    let { showForm, dispatch, formErrors, boardsFetched } = this.props;

    if (!showForm) return this._renderAddButton();

    return (
      <BoardForm
        dispatch={dispatch}
        errors={formErrors}
        onCancelClick={::this._handleCancelClick}/>
    );
  }

  _renderOtherBoards() {
    const {invitedBoards} = this.props;

    if (invitedBoards.length === 0) return false;

    return (
      <section>
        <header>
          <h2>Other boards</h2>
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
    let {showForm, dispatch, boardsFetched} = this.props;

    if (showForm && boardsFetched) return false;

    dispatch(Actions.showForm(true));
  }

  _handleCancelClick() {
    this.props.dispatch(Actions.showForm(false));
  }

  render() {
    return (
      <div className='view-container boards index'>
        <section>
          <header>
            <h2>My boards</h2>
          </header>
          <div className="boards-wrapper">
            {::this._renderBoards(this.props.ownedBoards)}
            {::this._renderAddNewBoard()}
          </div>
        </section>
        {::this._renderOtherBoards()}
      </div>
    );
  }
}

export default connect(mapStateToProps)(HomeIndexView);
