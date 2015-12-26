import React                    from 'react';
import ReactDOM                 from 'react-dom';
import Root                     from './containers/root';
import configureStore           from './store';
import createBrowserHistory     from 'history/lib/createBrowserHistory';
import { syncReduxAndRouter }   from 'redux-simple-router';

const target = document.getElementById('main_container');

const store  = configureStore(window.__INITIAL_STATE__);
const history = createBrowserHistory();

syncReduxAndRouter(history, store);

const node = <Root routerHistory={history} store={store}/>;
ReactDOM.render(node, target);
