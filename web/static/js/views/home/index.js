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

  _renderBoards() {
    return this.props.boards.map((board) => {
      return <BoardCard
                key={board.id}
                dispatch={this.props.dispatch}
                {...board} />;
    });
  }

  _renderAddNewBoard() {
    let { dispatch, formErrors, boardsFetched } = this.props;

    return (
      <BoardForm
        dispatch={dispatch}
        errors={formErrors}/>
    );
  }

  _handleAddNewClick() {
    let {showForm, dispatch, boardsFetched} = this.props;

    if (showForm && boardsFetched) return false;

    dispatch(Actions.showForm(true));
  }

  render() {
    return (
      <div className='view-container boards index'>
        <header>
          <h1>My boards</h1>
        </header>
        <div className="boards-wrapper">
          {::this._renderBoards()}
          {::this._renderAddNewBoard()}
        </div>
      </div>
    );
  }
}

export default connect(mapStateToProps)(HomeIndexView);
