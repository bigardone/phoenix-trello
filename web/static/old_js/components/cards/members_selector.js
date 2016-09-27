import React, {PropTypes} from 'react';
import PageClick          from 'react-page-click';
import ReactGravatar      from 'react-gravatar';
import classnames         from 'classnames';

import Actions            from '../../actions/current_card';

export default class MembersSelector extends React.Component {
  _close(e) {
    e.preventDefault();

    this.props.close();
  }

  _removeMember(memberId) {
    const { dispatch, channel, cardId } = this.props;

    dispatch(Actions.removeMember(channel, cardId, memberId));
  }

  _addMember(memberId) {
    const { dispatch, channel, cardId } = this.props;

    dispatch(Actions.addMember(channel, cardId, memberId));
  }

  _renderMembersList() {
    const { boardMembers, selectedMembers } = this.props;

    const members = boardMembers.map((member) => {
      const isMember = -1 != selectedMembers.findIndex((selectedMember) => { return selectedMember.id == member.id; });

      const handleOnClick = (e) => {
        e.preventDefault();

        return isMember ? this._removeMember(member.id) : this._addMember(member.id);
      };

      const iconClasses = classnames({
        fa: true,
        'fa-check': isMember,
      });

      const icon = (<i className={iconClasses}/>);

      return (
        <li key={member.id}>
          <a onClick={handleOnClick} href="#">
            <ReactGravatar className="react-gravatar" email={member.email} https />
            {`${member.first_name} ${member.last_name}`} {icon}
          </a>
        </li>
      );
    });

    return (
      <ul>
        {members}
      </ul>
    );
  }

  render() {
    return (
      <PageClick onClick={::this._close}>
        <div className="members-selector">
          <header>Members <a className="close" onClick={::this._close} href="#"><i className="fa fa-close" /></a></header>
          {::this._renderMembersList()}
        </div>
      </PageClick>
    );
  }
}

MembersSelector.propTypes = {
};
