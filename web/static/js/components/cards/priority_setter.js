import React, {PropTypes} from 'react';
import PageClick          from 'react-page-click';
import ReactGravatar      from 'react-gravatar';
import classnames         from 'classnames';

import Actions            from '../../actions/current_card';

export default class PrioritySetter extends React.Component {
  _close(e) {
    e.preventDefault();

    this.props.close();
  }

  _setPriority(priority) {
    const { dispatch, channel, cardId } = this.props;

    dispatch(Actions.updatePriority(channel, cardId, priority));
  }

  _renderPrioritiesList() {
    const { settedPriority } = this.props;

    const priorities = [ 'Low', 'Medium', 'High' ];

    const prioritiesNodes = priorities.map((priority) => {
      const isSelected = priority == settedPriority;

      const handleOnClick = (e) => {
        e.preventDefault();

        return this._setPriority(priority);
      };

      const linkClasses = classnames({
        selected: isSelected,
      });

      const iconClasses = classnames({
        fa: true,
        'fa-check': isSelected,
      });

      const icon = (<i className={iconClasses}/>);

      return (
        <li key={priority}>
          <a className={`priority ${priority} ${linkClasses}`} onClick={handleOnClick} href="#">
            {icon}
            {priority}
          </a>
        </li>
      );
    });

    return (
      <ul>
        {prioritiesNodes}
      </ul>
    );
  }

  render() {
    return (
      <PageClick onClick={::this._close}>
        <div className="priority-setter">
          <header>Priority <a className="close" onClick={::this._close} href="#"><i className="fa fa-close" /></a></header>
          {::this._renderPrioritiesList()}
        </div>
      </PageClick>
    );
  }
}
