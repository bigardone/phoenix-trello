import React, {PropTypes} from 'react';
import PageClick          from 'react-page-click';
import classnames         from 'classnames';

import Actions            from '../../actions/current_card';

export default class TeamSelector extends React.Component {
  _close(e) {
    e.preventDefault();

    this.props.close();
  }

  _removeTeam(boardId) {
    const { dispatch, channel, cardId } = this.props;

    dispatch(Actions.removeTeam(channel, cardId, boardId));
  }

  _addTeam(boardId) {
    const { dispatch, channel, cardId } = this.props;

    dispatch(Actions.addTeam(channel, cardId, boardId));
  }

  _renderTeamList() {
    const { teamBoards, selectedTeam } = this.props;

    const teams = teamBoards.map((board) => {
      
      const handleOnClick = (e) => {
        e.preventDefault();

        return this._addTeam(board.id);
      };

      const iconClasses = classnames({
        fa: true,
        'fa-check': isMember,
      });

      const icon = (<i className={iconClasses}/>);

      return (
        <li key={board.id}>
          <a onClick={handleOnClick} href="#">
            {`${board.name}`} {icon}
          </a>
        </li>
      );
    });

    return (
      <ul>
        {teams}
      </ul>
    );
  }

  render() {
    return (
      <PageClick onClick={::this._close}>
        <div className="team-selector">
          <header>Teams <a className="close" onClick={::this._close} href="#"><i className="fa fa-close" /></a></header>
          {::this._renderTeamList()}
        </div>
      </PageClick>
    );
  }
}

TeamSelector.propTypes = {
};
