import React, { PropTypes } from 'react';
import Actions              from '../../actions/lists';

export default class ListForm extends React.Component {
  _handleSubmit(e) {
    e.preventDefault();

    let { dispatch, channel }           = this.props;
    let { name, defaultLanguage, file } = this.refs;

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

  render() {
    return (
      <div className="list form">
        <div className="inner">
          <h4>New list</h4>
          <form onSubmit={::this._handleSubmit}>
            <input ref="name" type="text" placeholder="List name" required="true"/>
            {::this._renderErrors('name')}
            <button type="submit">Create list</button>
          </form>
        </div>
      </div>
    );
  }
}

ListForm.propTypes = {
};
