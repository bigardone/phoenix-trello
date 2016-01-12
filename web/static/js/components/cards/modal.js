import React, {PropTypes} from 'react';
import ReactGravatar      from 'react-gravatar';
import PageClick          from 'react-page-click';
import moment             from 'moment';
import Actions            from '../../actions/current_board';

export default class CardModal extends React.Component {
  _closeModal() {
    const { dispatch } = this.props;

    dispatch(Actions.resetEditCard());
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
            <ReactGravatar email={currentUser.email} https />
          </div>
          <div className="form-controls">
            <textarea ref="commentText" rows="5" placeholder="Write a comment..." required="true"/>
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
            <ReactGravatar email={user.email} https />
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

  render() {
    const { card } = this.props;

    return (
      <div className="md-overlay">
        <div className="md-modal">
          <PageClick onClick={::this._closeModal}>
            <div className="md-content card-modal">
              <header>
                <h3>{card.name}</h3>
              </header>
              <h5>Description</h5>
              <p>{card.description}</p>
              {::this._renderCommentForm()}
              {::this._renderComments(card)}
            </div>
          </PageClick>
        </div>
      </div>
    );
  }
}

CardModal.propTypes = {
};
