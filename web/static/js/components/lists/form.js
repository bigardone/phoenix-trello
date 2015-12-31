import React, { PropTypes } from 'react';
import Actions              from '../../actions/lists';
import PageClick                from 'react-page-click';

export default class ListForm extends React.Component {
  _handleSubmit(e) {
    e.preventDefault();

    let { dispatch, channel }           = this.props;
    let { name } = this.refs;

    let data = {
      name: name.value,
    };

    dispatch(Actions.create(channel, data));
  }

  _renderErrors(field) {
    const {errors} = this.props;

    if (!errors) return false;

    return errors.map((error, i) => {
      if (error[field]) {
        return (
          <div key={i} className="error">
            {error[field]}
          </div>
        );
      }
    });
  }

  _handleCancelClick(e) {
    e.preventDefault();

    this.props.onCancelClick();
  }

  render() {
    return (
      <PageClick onClick={::this._handleCancelClick}>
        <div className="list form">
          <div className="inner">
            <form onSubmit={::this._handleSubmit}>
              <input ref="name" type="text" placeholder="Add a new list..." required="true"/>
              {::this._renderErrors('name')}
              <button type="submit">Create list</button> or <a href="#" onClick={::this._handleCancelClick}>cancel</a>
            </form>
          </div>
        </div>
      </PageClick>
    );
  }
}

ListForm.propTypes = {
};
