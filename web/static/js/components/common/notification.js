import React, {PropTypes} from 'react';
import Actions            from '../../actions/notification';
import classnames         from 'classnames';

export default class Notification extends React.Component {
  static propTypes = {
    type: React.PropTypes.string,
    text: React.PropTypes.string,
  }

  constructor(props) {
    super(props);

    this.timeoutId = null;
  }

  componentDidMount() {
    this.timeoutId = this._setTimeout();
  }

  componentDidUpdate() {
    const {text} = this.props;

    if (text != null) {
      clearTimeout(this.timeoutId);
      this.timeoutId = this._setTimeout();
    }
  }

  _setTimeout() {
    const {dispatch} = this.props;

    setTimeout(() => {
      dispatch(Actions.remove());
    }, 3000);
  }

  render() {
    const classes = classnames({
      'notification-box': true,
      'notification-show': this.props.show,
    });

    return (
      <div className={classes}>
        {this.props.text}
      </div>
    );
  }
}
