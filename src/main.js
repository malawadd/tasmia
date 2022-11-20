// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import VModal from 'vue-js-modal'
import router from './router'

require('expose-loader?$!expose-loader?jQuery!jquery');
require('jquery-csv');
require('popper.js');
require('bootstrap');
require('bootstrap/dist/css/bootstrap.min.css');

// register global components (prefix 'Base'-)
import '@/components/globals'

Vue.use(VModal);

Vue.directive('visible', (el, binding) => {
    el.style.visibility = !!binding.value ? 'visible' : 'hidden'
});

new Vue({
	el: '#app',
	template: '<App/>',
	components: { App },
	router
}).$mount('#app');