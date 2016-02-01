import React, { PropTypes } from 'react';
import Actions              from '../../actions/boards';
import PageClick            from 'react-page-click';
import {renderErrorsFor}    from '../../utils';

export default class BoardForm extends React.Component {
  componentDidMount() {
    this.refs.name.focus();
  }

  _handleSubmit(e) {
    e.preventDefault();

    const { dispatch } = this.props;
    const { name } = this.refs;

    const data = {
      name: name.value,
    };

    dispatch(Actions.create(data));
  }

  _handleCancelClick(e) {
    e.preventDefault();

    this.props.onCancelClick();
  }

  render() {
    const { errors } = this.props;

    return (
      <PageClick onClick={::this._handleCancelClick}>
        <div className="board form">
          <div className="inner">
            <h4>New board</h4>
            <form id="new_board_form" onSubmit={::this._handleSubmit}>
              <input ref="name" id="board_name" type="text" placeholder="Board name" required="true"/>
              {renderErrorsFor(errors, 'name')}
              <button type="submit">Create board</button> or <a href="#" onClick={::this._handleCancelClick}>cancel</a>
            </form>
          </div>
        </div>
      </PageClick>
    );
  }
}
