import React, {PropTypes} from 'react';
import ReactGravatar      from 'react-gravatar';
import PageClick          from 'react-page-click';
import moment             from 'moment';
import { push }           from 'react-router-redux';

import Actions            from '../../actions/current_card';
import BoardActions       from '../../actions/current_board';
import MembersSelector    from './members_selector';
import TagsSelector       from './tags_selector';
import PrioritySetter     from './priority_setter';

export default class CardModal extends React.Component {
  componentDidUpdate() {
    const { edit } = this.props;

    if (edit) this.refs.name.focus();
  }

  _closeModal(e) {
    e.preventDefault();

    const { dispatch, boardId } = this.props;

    dispatch(push(`/boards/${boardId}`));
  }

  _renderCommentForm() {
    const { currentUser } = this.props;

    return (
      <div className="form-wrapper">
        <form onSubmit={::this._handleCommentFormSubmit}>
          <header>
            <h4>Add comment</h4>
          </header>
          <div className="gravatar-wrapper">
            <ReactGravatar className="react-gravatar" email={currentUser.email} https />
          </div>
          <div className="form-controls">
            <textarea
              ref="commentText"
              rows="3"
              placeholder="Write a comment..."
              required="true"/>
            <button type="submit">Save comment</button>
          </div>
        </form>
      </div>
    );
  }

  _handleCommentFormSubmit(e) {
    e.preventDefault();

    const { id } = this.props.card;
    const { channel, dispatch } = this.props;
    const { commentText } = this.refs;

    const comment = {
      card_id: id,
      text: commentText.value.trim(),
    };

    dispatch(Actions.createCardComment(channel, comment));

    commentText.value = '';
  }

  _renderComments(card) {
    if (card.comments.length == 0) return false;

    const comments = card.comments.map((comment) => {
      const { user } = comment;

      return (
        <div key={comment.id} className="comment">
          <div className="gravatar-wrapper">
            <ReactGravatar className="react-gravatar" email={user.email} https />
          </div>
          <div className="info-wrapper">
            <h5>{user.first_name}</h5>
            <div className="text">
              {comment.text}
            </div>
            <small>{moment(comment.inserted_at).fromNow()}</small>
          </div>
        </div>
      );
    });

    return (
      <div className="comments-wrapper">
        <h4>Activity</h4>
        {comments}
      </div>
    );
  }

  _renderDescription() {
    const { card, editDescription } = this.props;

    if (editDescription) {
      return (
        <form onSubmit={::this._handleDescriptionSubmit}>
          <h5>Description</h5>
          <textarea
            ref="description"
            type="text"
            placeholder="Description"
            rows="5"
            defaultValue={card.description} />
          <button type="submit">Save</button> or <a href="#" onClick={::this._handleDescriptionCancel}>cancel</a>
        </form>
      );
    }
    else {
      return (
        <div>
          <h5>Description</h5>
          <div className="description">{card.description}</div>
          <a href="#" onClick={::this._handleDescriptionClick}>Edit</a>
        </div>
      );
    }
  }

  _handleDescriptionClick(e) {
    e.preventDefault();
    const { dispatch } = this.props;
    dispatch(Actions.editDescription(true))
  }

  _handleDescriptionCancel(e) {
    e.preventDefault();
    const { dispatch } = this.props;
    dispatch(Actions.editDescription(false));
  }

  _handleDescriptionSubmit(e) {
    e.preventDefault();

    const { description } = this.refs;

    const { card } = this.props;

    card.description = description.value.trim();

    const { channel, dispatch } = this.props;

    dispatch(BoardActions.updateCard(channel, card));
    dispatch(Actions.editDescription(false));
  }


  _handleStarClick(e) {
    e.preventDefault();

    const { card } = this.props;

    const { channel, dispatch } = this.props;

    card.priority = !card.priority;

    dispatch(BoardActions.updateCard(channel, card))
  }

  _renderStar() {
    const { card } = this.props;

    if (card.priority) {
      return (
        <i className="fa fa-star"/>
      );
    }
    else {
      return (
        <i className="fa fa-star-o"/>
      );
    }
  }

  _renderTitle() {
    const { card, editTitle } = this.props;

    if(editTitle) {
      return (
        <PageClick onClick={::this._handleTitleClose}>
          <input
            ref="name"
            type="text"
            placeholder="Title"
            required="true"
            defaultValue={card.name}/>
        </PageClick>
      );
    }
    else {
      return (
        <h3>
          <a href="#" onClick={::this._handleTitleClick}>{card.name}</a>
          <a href="#" onClick={::this._handleStarClick}>{::this._renderStar()}</a>
        </h3>
      );
    }
  }

  _handleTitleClick(e) {
    e.preventDefault();

    const { dispatch } = this.props;
    dispatch(Actions.editTitle(true))
  }

  _handleTitleClose(e) {
    e.preventDefault();

    const { name } = this.refs;

    const { card } = this.props;

    const { channel, dispatch } = this.props;

    if (name != card.name) {
      card.name = name.value.trim();

      dispatch(BoardActions.updateCard(channel, card));
    }

    dispatch(Actions.editTitle(false));
  }

  _renderHeader() {
    const { card } = this.props;

    return (
      <header>
        {::this._renderTitle()}
        <div className="items-wrapper">
          {::this._renderMembers()}
          {::this._renderTags()}
        </div>
        {::this._renderDescription()}
      </header>
    );
  }

  _renderMembers() {
    const { members } = this.props.card;

    if (members.length == 0) return false;

    const memberNodes = members.map((member) => {
      return <ReactGravatar className="react-gravatar" key={member.id} email={member.email} https />;
    });

    return (
      <div className="card-members">
      <h5>Members</h5>
        {memberNodes}
      </div>
    );
  }

  _renderTags() {
    const { tags } = this.props.card;

    if (tags.length == 0) return false;

    const tagsNodes = tags.map((tag) => {
      return <div key={tag} className={`tag ${tag}`}></div>;
    });

    return (
      <div className="card-tags">
      <h5>Colors</h5>
        {tagsNodes}
      </div>
    );
  }

  _handleShowMembersClick(e) {
    e.preventDefault();

    const { dispatch } = this.props;

    dispatch(Actions.showMembersSelector(true));
  }

  _handleShowTagsClick(e) {
    e.preventDefault();

    const { dispatch } = this.props;

    dispatch(Actions.showTagsSelector(true));
  }

  // _handleShowPriorityClick(e) {
  //   e.preventDefault();
  //
  //   const { dispatch } = this.props;
  //
  //   dispatch(Actions.showPrioritySetter(true));
  // }

  _renderMembersSelector() {
    const { card, boardMembers, showMembersSelector, dispatch, channel } = this.props;
    const { members } = card;

    if (!showMembersSelector) return false;

    return (
      <MembersSelector
        channel={channel}
        cardId={card.id}
        dispatch={dispatch}
        boardMembers={boardMembers}
        selectedMembers={members}
        close={::this._onMembersSelectorClose} />
    );
  }

  _onMembersSelectorClose() {
    const { dispatch } = this.props;

    dispatch(Actions.showMembersSelector(false));
  }

  _renderTagsSelector() {
    const { card, showTagsSelector, dispatch, channel } = this.props;
    const { tags } = card;

    if (!showTagsSelector) return false;

    return (
      <TagsSelector
        channel={channel}
        cardId={card.id}
        dispatch={dispatch}
        selectedTags={tags}
        close={::this._onTagsSelectorClose} />
    );
  }

  _onTagsSelectorClose() {
    const { dispatch } = this.props;

    dispatch(Actions.showTagsSelector(false));
  }

  // _renderPrioritySetter() {
  //   const { card, showPrioritySetter, dispatch, channel } = this.props;
  //   const { priority } = card;
  //
  //   if(!showPrioritySetter) return false;
  //
  //   return (
  //     <PrioritySetter
  //       channel={channel}
  //       cardId={card.id}
  //       dispatch={dispatch}
  //       settedPriority={priority}
  //       close={::this._onPrioritySetterClose}/>
  //   )
  // }
  //
  // _onPrioritySetterClose() {
  //   const { dispatch } = this.props;
  //
  //   dispatch(Actions.showPrioritySetter(false));
  // }

  render() {
    const { card, boardMembers, showMembersSelector } = this.props;
    const { members } = card;

    return (
      <div className="md-overlay">
        <div className="md-modal">
          <PageClick onClick={::this._closeModal}>
            <div className="md-content card-modal">
              <a className="close" href="#" onClick={::this._closeModal}>
                <i className="fa fa-close"/>
              </a>
              <div className="info">
                {::this._renderHeader()}
                {::this._renderCommentForm()}
                {::this._renderComments(card)}
              </div>
              <div className="options">
                <h4>Add</h4>
                <a className="button" href="#" onClick={::this._handleShowMembersClick}>
                  <i className="fa fa-user"/> Members
                </a>
                {::this._renderMembersSelector()}
                <a className="button" href="#" onClick={::this._handleShowTagsClick}>
                  <i className="fa fa-tag"/> Colors
                </a>
                {::this._renderTagsSelector()}
              </div>
            </div>
          </PageClick>
        </div>
      </div>
    );
  }
}

// <a className="button" href="#" onClick={::this._handleShowPriorityClick}>
//   <i className="fa fa-tasks"/> Priority
// </a>
// {::this._renderPrioritySetter()}

CardModal.propTypes = {
};
