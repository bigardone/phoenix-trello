import React              from 'react';
import { Provider }       from 'react-redux';
import { Router }         from 'react-router';
import invariant          from 'invariant';
import { RoutingContext } from 'react-router';
import configRoutes       from '../routes';

export default class Root extends React.Component {
  _renderRouter(store) {
    invariant(this.props.routerHistory,
      '<Root /> needs either a routingContext or routerHistory to render.'
    );

    return (
      <Router history={this.props.routerHistory}>
        {configRoutes(store)}
      </Router>
    );
  }

  render() {
    const { store } = this.props;

    return (
      <Provider store={store}>
        {this._renderRouter(store)}
      </Provider>
    );
  }
}
