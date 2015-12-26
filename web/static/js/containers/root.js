import React        from 'react';
import { Provider } from 'react-redux';
import { Router }   from 'react-router';
import invariant    from 'invariant';
import routes       from '../routes';
import { RoutingContext } from 'react-router';

export default class Root extends React.Component {
  constructor() {
    super();
  }

  renderRouter() {
    invariant(
      this.props.routingContext || this.props.routerHistory,
      '<Root /> needs either a routingContext or routerHistory to render.'
    );

    if (this.props.routingContext) {
      return <RoutingContext {...this.props.routingContext} />;
    } else {
      return (
        <Router history={this.props.routerHistory}>
          {routes}
        </Router>
      );
    }
  }

  render() {
    return (
      <Provider store={this.props.store}>
        {this.renderRouter()}
      </Provider>
    );
  }
}
