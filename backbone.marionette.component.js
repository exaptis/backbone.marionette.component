/**
 * @license almond 0.3.0 Copyright (c) 2011-2014, The Dojo Foundation All Rights Reserved.
 * Available via the MIT or new BSD license.
 * see: http://github.com/jrburke/almond for details
 */
//Going sloppy to avoid 'use strict' string cost, but strict practices should
//be followed.
/*jslint sloppy: true */
/*global setTimeout: false */

var requirejs, require, define;
(function (undef) {
    var main, req, makeMap, handlers,
        defined = {},
        waiting = {},
        config = {},
        defining = {},
        hasOwn = Object.prototype.hasOwnProperty,
        aps = [].slice,
        jsSuffixRegExp = /\.js$/;

    function hasProp(obj, prop) {
        return hasOwn.call(obj, prop);
    }

    /**
     * Given a relative module name, like ./something, normalize it to
     * a real name that can be mapped to a path.
     * @param {String} name the relative name
     * @param {String} baseName a real name that the name arg is relative
     * to.
     * @returns {String} normalized name
     */
    function normalize(name, baseName) {
        var nameParts, nameSegment, mapValue, foundMap, lastIndex,
            foundI, foundStarMap, starI, i, j, part,
            baseParts = baseName && baseName.split("/"),
            map = config.map,
            starMap = (map && map['*']) || {};

        //Adjust any relative paths.
        if (name && name.charAt(0) === ".") {
            //If have a base name, try to normalize against it,
            //otherwise, assume it is a top-level require that will
            //be relative to baseUrl in the end.
            if (baseName) {
                //Convert baseName to array, and lop off the last part,
                //so that . matches that "directory" and not name of the baseName's
                //module. For instance, baseName of "one/two/three", maps to
                //"one/two/three.js", but we want the directory, "one/two" for
                //this normalization.
                baseParts = baseParts.slice(0, baseParts.length - 1);
                name = name.split('/');
                lastIndex = name.length - 1;

                // Node .js allowance:
                if (config.nodeIdCompat && jsSuffixRegExp.test(name[lastIndex])) {
                    name[lastIndex] = name[lastIndex].replace(jsSuffixRegExp, '');
                }

                name = baseParts.concat(name);

                //start trimDots
                for (i = 0; i < name.length; i += 1) {
                    part = name[i];
                    if (part === ".") {
                        name.splice(i, 1);
                        i -= 1;
                    } else if (part === "..") {
                        if (i === 1 && (name[2] === '..' || name[0] === '..')) {
                            //End of the line. Keep at least one non-dot
                            //path segment at the front so it can be mapped
                            //correctly to disk. Otherwise, there is likely
                            //no path mapping for a path starting with '..'.
                            //This can still fail, but catches the most reasonable
                            //uses of ..
                            break;
                        } else if (i > 0) {
                            name.splice(i - 1, 2);
                            i -= 2;
                        }
                    }
                }
                //end trimDots

                name = name.join("/");
            } else if (name.indexOf('./') === 0) {
                // No baseName, so this is ID is resolved relative
                // to baseUrl, pull off the leading dot.
                name = name.substring(2);
            }
        }

        //Apply map config if available.
        if ((baseParts || starMap) && map) {
            nameParts = name.split('/');

            for (i = nameParts.length; i > 0; i -= 1) {
                nameSegment = nameParts.slice(0, i).join("/");

                if (baseParts) {
                    //Find the longest baseName segment match in the config.
                    //So, do joins on the biggest to smallest lengths of baseParts.
                    for (j = baseParts.length; j > 0; j -= 1) {
                        mapValue = map[baseParts.slice(0, j).join('/')];

                        //baseName segment has  config, find if it has one for
                        //this name.
                        if (mapValue) {
                            mapValue = mapValue[nameSegment];
                            if (mapValue) {
                                //Match, update name to the new value.
                                foundMap = mapValue;
                                foundI = i;
                                break;
                            }
                        }
                    }
                }

                if (foundMap) {
                    break;
                }

                //Check for a star map match, but just hold on to it,
                //if there is a shorter segment match later in a matching
                //config, then favor over this star map.
                if (!foundStarMap && starMap && starMap[nameSegment]) {
                    foundStarMap = starMap[nameSegment];
                    starI = i;
                }
            }

            if (!foundMap && foundStarMap) {
                foundMap = foundStarMap;
                foundI = starI;
            }

            if (foundMap) {
                nameParts.splice(0, foundI, foundMap);
                name = nameParts.join('/');
            }
        }

        return name;
    }

    function makeRequire(relName, forceSync) {
        return function () {
            //A version of a require function that passes a moduleName
            //value for items that may need to
            //look up paths relative to the moduleName
            var args = aps.call(arguments, 0);

            //If first arg is not require('string'), and there is only
            //one arg, it is the array form without a callback. Insert
            //a null so that the following concat is correct.
            if (typeof args[0] !== 'string' && args.length === 1) {
                args.push(null);
            }
            return req.apply(undef, args.concat([relName, forceSync]));
        };
    }

    function makeNormalize(relName) {
        return function (name) {
            return normalize(name, relName);
        };
    }

    function makeLoad(depName) {
        return function (value) {
            defined[depName] = value;
        };
    }

    function callDep(name) {
        if (hasProp(waiting, name)) {
            var args = waiting[name];
            delete waiting[name];
            defining[name] = true;
            main.apply(undef, args);
        }

        if (!hasProp(defined, name) && !hasProp(defining, name)) {
            throw new Error('No ' + name);
        }
        return defined[name];
    }

    //Turns a plugin!resource to [plugin, resource]
    //with the plugin being undefined if the name
    //did not have a plugin prefix.
    function splitPrefix(name) {
        var prefix,
            index = name ? name.indexOf('!') : -1;
        if (index > -1) {
            prefix = name.substring(0, index);
            name = name.substring(index + 1, name.length);
        }
        return [prefix, name];
    }

    /**
     * Makes a name map, normalizing the name, and using a plugin
     * for normalization if necessary. Grabs a ref to plugin
     * too, as an optimization.
     */
    makeMap = function (name, relName) {
        var plugin,
            parts = splitPrefix(name),
            prefix = parts[0];

        name = parts[1];

        if (prefix) {
            prefix = normalize(prefix, relName);
            plugin = callDep(prefix);
        }

        //Normalize according
        if (prefix) {
            if (plugin && plugin.normalize) {
                name = plugin.normalize(name, makeNormalize(relName));
            } else {
                name = normalize(name, relName);
            }
        } else {
            name = normalize(name, relName);
            parts = splitPrefix(name);
            prefix = parts[0];
            name = parts[1];
            if (prefix) {
                plugin = callDep(prefix);
            }
        }

        //Using ridiculous property names for space reasons
        return {
            f: prefix ? prefix + '!' + name : name, //fullName
            n: name,
            pr: prefix,
            p: plugin
        };
    };

    function makeConfig(name) {
        return function () {
            return (config && config.config && config.config[name]) || {};
        };
    }

    handlers = {
        require: function (name) {
            return makeRequire(name);
        },
        exports: function (name) {
            var e = defined[name];
            if (typeof e !== 'undefined') {
                return e;
            } else {
                return (defined[name] = {});
            }
        },
        module: function (name) {
            return {
                id: name,
                uri: '',
                exports: defined[name],
                config: makeConfig(name)
            };
        }
    };

    main = function (name, deps, callback, relName) {
        var cjsModule, depName, ret, map, i,
            args = [],
            callbackType = typeof callback,
            usingExports;

        //Use name if no relName
        relName = relName || name;

        //Call the callback to define the module, if necessary.
        if (callbackType === 'undefined' || callbackType === 'function') {
            //Pull out the defined dependencies and pass the ordered
            //values to the callback.
            //Default to [require, exports, module] if no deps
            deps = !deps.length && callback.length ? ['require', 'exports', 'module'] : deps;
            for (i = 0; i < deps.length; i += 1) {
                map = makeMap(deps[i], relName);
                depName = map.f;

                //Fast path CommonJS standard dependencies.
                if (depName === "require") {
                    args[i] = handlers.require(name);
                } else if (depName === "exports") {
                    //CommonJS module spec 1.1
                    args[i] = handlers.exports(name);
                    usingExports = true;
                } else if (depName === "module") {
                    //CommonJS module spec 1.1
                    cjsModule = args[i] = handlers.module(name);
                } else if (hasProp(defined, depName) ||
                           hasProp(waiting, depName) ||
                           hasProp(defining, depName)) {
                    args[i] = callDep(depName);
                } else if (map.p) {
                    map.p.load(map.n, makeRequire(relName, true), makeLoad(depName), {});
                    args[i] = defined[depName];
                } else {
                    throw new Error(name + ' missing ' + depName);
                }
            }

            ret = callback ? callback.apply(defined[name], args) : undefined;

            if (name) {
                //If setting exports via "module" is in play,
                //favor that over return value and exports. After that,
                //favor a non-undefined return value over exports use.
                if (cjsModule && cjsModule.exports !== undef &&
                        cjsModule.exports !== defined[name]) {
                    defined[name] = cjsModule.exports;
                } else if (ret !== undef || !usingExports) {
                    //Use the return value from the function.
                    defined[name] = ret;
                }
            }
        } else if (name) {
            //May just be an object definition for the module. Only
            //worry about defining if have a module name.
            defined[name] = callback;
        }
    };

    requirejs = require = req = function (deps, callback, relName, forceSync, alt) {
        if (typeof deps === "string") {
            if (handlers[deps]) {
                //callback in this case is really relName
                return handlers[deps](callback);
            }
            //Just return the module wanted. In this scenario, the
            //deps arg is the module name, and second arg (if passed)
            //is just the relName.
            //Normalize module name, if it contains . or ..
            return callDep(makeMap(deps, callback).f);
        } else if (!deps.splice) {
            //deps is a config object, not an array.
            config = deps;
            if (config.deps) {
                req(config.deps, config.callback);
            }
            if (!callback) {
                return;
            }

            if (callback.splice) {
                //callback is an array, which means it is a dependency list.
                //Adjust args if there are dependencies
                deps = callback;
                callback = relName;
                relName = null;
            } else {
                deps = undef;
            }
        }

        //Support require(['a'])
        callback = callback || function () {};

        //If relName is a function, it is an errback handler,
        //so remove it.
        if (typeof relName === 'function') {
            relName = forceSync;
            forceSync = alt;
        }

        //Simulate async callback;
        if (forceSync) {
            main(undef, deps, callback, relName);
        } else {
            //Using a non-zero value because of concern for what old browsers
            //do, and latest browsers "upgrade" to 4 if lower value is used:
            //http://www.whatwg.org/specs/web-apps/current-work/multipage/timers.html#dom-windowtimers-settimeout:
            //If want a value immediately, use require('id') instead -- something
            //that works in almond on the global level, but not guaranteed and
            //unlikely to work in other AMD implementations.
            setTimeout(function () {
                main(undef, deps, callback, relName);
            }, 4);
        }

        return req;
    };

    /**
     * Just drops the config on the floor, but returns req in case
     * the config return value is used.
     */
    req.config = function (cfg) {
        return req(cfg);
    };

    /**
     * Expose module registry for debugging and tooling
     */
    requirejs._defined = defined;

    define = function (name, deps, callback) {

        //This module may not have dependencies
        if (!deps.splice) {
            //deps is not an array, so probably means
            //an object literal or factory function for
            //the value. Adjust args.
            callback = deps;
            deps = [];
        }

        if (!hasProp(defined, name) && !hasProp(waiting, name)) {
            waiting[name] = [name, deps, callback];
        }
    };

    define.amd = {
        jQuery: true
    };
}());

define("../../../bower_components/almond/almond", function(){});

define('lib/component/utils/InstanceCounter',[], function() {
  
  var InstanceCounter, _base, _base1;
  InstanceCounter = (function() {
    function InstanceCounter() {
      var counter;
      counter = 0;
      this.getCounter = function() {
        return counter;
      };
      this.incrementCounter = function() {
        return ++counter;
      };
    }

    return InstanceCounter;

  })();
  (_base = Backbone.Marionette).Component || (_base.Component = {});
  return (_base1 = Backbone.Marionette.Component).InstanceCounter || (_base1.InstanceCounter = InstanceCounter);
});

//# sourceMappingURL=InstanceCounter.js.map
;
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define('lib/component/validation/ValidationError',['i18next', 'underscore.string'], function(i18next) {
  
  var ValidationError, _base, _base1;
  ValidationError = (function(_super) {
    __extends(ValidationError, _super);

    function ValidationError() {
      return ValidationError.__super__.constructor.apply(this, arguments);
    }

    ValidationError.prototype.defaults = {
      errorMessage: ''
    };

    ValidationError.prototype.initialize = function(attributes, options) {
      this.validatorName = options.validatorName, this.validationName = options.validationName, this.componentId = options.componentId;
      this.on('change', this.updateErrorMessage);
      return this.updateErrorMessage();
    };

    ValidationError.prototype.updateErrorMessage = function() {
      return this.set('errorMessage', i18next.t(this.getErrorKey(), this.getErrorValues(), {
        silent: true
      }));
    };

    ValidationError.prototype.getComponentId = function() {
      return this.componentId;
    };

    ValidationError.prototype.getErrorKey = function() {
      var errorKey;
      errorKey = [];
      errorKey.push(this.componentId);
      errorKey.push(this.validatorName);
      errorKey.push(this.validationName);
      errorKey = _.map(errorKey, function(name) {
        return _.string.capitalize(name);
      });
      return errorKey.join('.');
    };

    ValidationError.prototype.getErrorValues = function() {
      return _.omit(this.toJSON(), 'errorMessage');
    };

    return ValidationError;

  })(Backbone.Model);
  (_base = Backbone.Marionette).Component || (_base.Component = {});
  return (_base1 = Backbone.Marionette.Component).ValidationError || (_base1.ValidationError = ValidationError);
});

//# sourceMappingURL=ValidationError.js.map
;
define('lib/component/validation/validator/BaseValidator',[], function() {
  
  var BaseValidator, _base, _base1;
  BaseValidator = (function() {
    function BaseValidator() {}

    BaseValidator.prototype.validate = function() {};

    BaseValidator.prototype.onComponentTag = function() {};

    return BaseValidator;

  })();
  (_base = Backbone.Marionette).Component || (_base.Component = {});
  return (_base1 = Backbone.Marionette.Component).BaseValidator || (_base1.BaseValidator = BaseValidator);
});

//# sourceMappingURL=BaseValidator.js.map
;
var __slice = [].slice;

define('lib/component/Component',['lib/component/utils/InstanceCounter', 'lib/component/validation/ValidationError', 'lib/component/validation/validator/BaseValidator'], function() {
  
  var Component, _base;
  Component = (function() {

    /*
     Private instance counter for generating unique ids
     */
    var compentInstanceCounter;

    compentInstanceCounter = new Backbone.Marionette.Component.InstanceCounter;

    Component.prototype.triggerMethod = Marionette.triggerMethod;

    function Component(componentId) {
      this.componentId = componentId;
      if (!this.componentId) {
        throw new Error("componentId needs to be specified");
      }
      this.cid = 'c' + compentInstanceCounter.incrementCounter();
      this._validators = [];
      this._validationErrors = [];
      this.parentComponent = null;
    }

    Component.prototype.setComponentId = function(componentId) {
      this.componentId = componentId;
    };

    Component.prototype.getComponentId = function() {
      return this.componentId;
    };

    Component.prototype.setModel = function(model) {
      this.model = model;
    };

    Component.prototype.getModel = function() {
      return this.model;
    };

    Component.prototype.setProperty = function(property) {
      this.property = property;
    };

    Component.prototype.getProperty = function() {
      return this.property;
    };

    Component.prototype.setViewInstance = function(viewInstance) {
      this.viewInstance = viewInstance;
    };

    Component.prototype.getViewInstance = function() {
      return this.viewInstance;
    };

    Component.prototype.setParent = function(parent) {
      this.parent = parent;
    };

    Component.prototype.getParent = function() {
      return this.parent;
    };

    Component.prototype.getValue = function() {
      return this.model.get(this.property);
    };

    Component.prototype.getValidationErrors = function() {
      return this._validationErrors;
    };


    /*
      Retrieve dom node from viewInstance
     */

    Component.prototype.getDomNode = function() {
      var domNode;
      domNode = this.viewInstance.$("[component-id='" + this.componentId + "']");
      if (!domNode.length) {
        throw new Error("element with id '" + this.componentId + "' could not be found");
      }
      return domNode;
    };


    /*
      Return key:value object for data binding
     */

    Component.prototype.getModelData = function() {
      var data;
      data = {};
      data["" + this.cid] = this.model;
      return data;
    };


    /*
      Add validators to the component
     */

    Component.prototype.add = function() {
      var component, components, _i, _len, _results;
      components = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      _results = [];
      for (_i = 0, _len = components.length; _i < _len; _i++) {
        component = components[_i];
        if (component instanceof Backbone.Marionette.Component.BaseValidator) {
          this._validators.push(component);
        }
        if (component instanceof Backbone.Marionette.Component.ValidationError) {
          _results.push(this._validationErrors.push(component));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };


    /*
      Called when the component is rendered
     */

    Component.prototype.render = function() {};


    /*
      Called when the component is closed
     */

    Component.prototype.close = function() {};


    /*
      Called when the component is validated
     */

    Component.prototype.validate = function() {
      var validator, _i, _len, _ref, _results;
      this._validationErrors = [];
      _ref = this._validators;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        validator = _ref[_i];
        _results.push(validator.validate(this));
      }
      return _results;
    };


    /*
      Called when the component is destroyed
     */

    Component.prototype.destroy = function() {
      if (this.parent) {
        return delete this.parent;
      }
    };

    _.extend(Component.prototype, Backbone.Events);

    return Component;

  })();
  Backbone.Marionette || (Backbone.Marionette = {});
  return (_base = Backbone.Marionette.Component).Component || (_base.Component = Component);
});

//# sourceMappingURL=Component.js.map
;
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define('lib/component/form/Button',['lib/component/Component'], function() {
  
  var Button, _base, _base1;
  Button = (function(_super) {
    __extends(Button, _super);

    function Button(componentId, callback) {
      this.componentId = componentId;
      this.callback = callback;
      if (!this.callback) {
        throw new Error("no callback specified");
      }
      Button.__super__.constructor.call(this, this.componentId);
    }

    Button.prototype.render = function() {
      return this.getDomNode().on('click', (function(_this) {
        return function(event) {
          return _this.callback.call(_this.viewInstance, event);
        };
      })(this));
    };

    Button.prototype.close = function() {
      return this.getDomNode().off('click');
    };

    return Button;

  })(Backbone.Marionette.Component.Component);
  (_base = Backbone.Marionette).Component || (_base.Component = {});
  return (_base1 = Backbone.Marionette.Component).Button || (_base1.Button = Button);
});

//# sourceMappingURL=Button.js.map
;
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define('lib/component/form/Checkbox',['lib/component/Component'], function() {
  
  var Checkbox, _base, _base1;
  Checkbox = (function(_super) {
    var defaultInputType;

    __extends(Checkbox, _super);

    defaultInputType = 'checkbox';

    function Checkbox(componentId, property, model) {
      this.componentId = componentId;
      this.property = property;
      this.model = model;
      if (!this.model) {
        throw new Error("model needs to be specified");
      }
      Checkbox.__super__.constructor.call(this, this.componentId);
    }

    Checkbox.prototype.render = function() {
      var domNode;
      domNode = this.getDomNode();
      domNode.attr('type', defaultInputType);
      return domNode.attr('rv-checked', "" + this.cid + ":" + this.property);
    };

    return Checkbox;

  })(Backbone.Marionette.Component.Component);
  (_base = Backbone.Marionette).Component || (_base.Component = {});
  return (_base1 = Backbone.Marionette.Component).Checkbox || (_base1.Checkbox = Checkbox);
});

//# sourceMappingURL=Checkbox.js.map
;
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define('lib/component/form/Dropdown',['lib/component/Component'], function() {
  
  var Dropdown, _base, _base1;
  Dropdown = (function(_super) {
    __extends(Dropdown, _super);

    function Dropdown(componentId, property, model, collection) {
      this.componentId = componentId;
      this.property = property;
      this.model = model;
      this.collection = collection;
      if (!this.model) {
        throw new Error('model needs to be specified');
      }
      if (!this.collection) {
        throw new Error('collection needs to be specified');
      }
      Dropdown.__super__.constructor.call(this, this.componentId);
    }

    Dropdown.prototype.render = function() {
      var ITEM_NAME, optionNode, selectNode;
      ITEM_NAME = 'option';
      optionNode = $('<option>');
      optionNode.attr("rv-each-" + ITEM_NAME, "collection" + this.cid + ":models");
      optionNode.attr('rv-value', "" + ITEM_NAME + ":value");
      optionNode.attr('rv-text', "" + ITEM_NAME + ":text");
      selectNode = this.getDomNodes();
      selectNode.attr('rv-value', "model" + this.cid + ":" + this.property);
      return selectNode.append(optionNode);
    };

    Dropdown.prototype.getModelData = function() {
      var data;
      data = {};
      data["model" + this.cid] = this.model;
      data["collection" + this.cid] = this.collection;
      return data;
    };


    /*
      Return the option dom elements
     */

    Dropdown.prototype.getDomNodes = function() {
      return Backbone.Marionette.Component.Component.prototype.getDomNode.call(this, arguments);
    };


    /*
      Unsupported for this component, as more than one dom node can be returned.
     */

    Dropdown.prototype.getDomNode = function() {
      throw new Error('Unsupported Method, use getDomNodes() instead.');
    };

    return Dropdown;

  })(Backbone.Marionette.Component.Component);
  (_base = Backbone.Marionette).Component || (_base.Component = {});
  return (_base1 = Backbone.Marionette.Component).Dropdown || (_base1.Dropdown = Dropdown);
});

//# sourceMappingURL=Dropdown.js.map
;
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define('lib/component/form/RadioButton',['lib/component/Component'], function() {
  
  var RadioButton, _base, _base1;
  RadioButton = (function(_super) {
    var defaultInputType;

    __extends(RadioButton, _super);

    defaultInputType = 'radio';

    function RadioButton(componentId, property, model, collection) {
      this.componentId = componentId;
      this.property = property;
      this.model = model;
      this.collection = collection;
      if (!this.model) {
        throw new Error('model needs to be specified');
      }
      if (!this.collection) {
        throw new Error('collection needs to be specified');
      }
      RadioButton.__super__.constructor.call(this, this.componentId);
    }

    RadioButton.prototype.render = function() {
      var ITEM_NAME, labelNode, optionNode, repeatingElement, textNode;
      ITEM_NAME = 'radio';
      labelNode = $('<label>');
      optionNode = this.getDomNodes();
      optionNode.attr('type', defaultInputType);
      optionNode.attr('rv-value', "" + ITEM_NAME + ":value");
      optionNode.attr('rv-checked', "model" + this.cid + ":" + this.property);
      repeatingElement = $('<div>');
      repeatingElement.attr('class', optionNode.parent().attr('class'));
      repeatingElement.attr("rv-each-" + ITEM_NAME, "collection" + this.cid + ":models");
      optionNode.parent().attr('class', '');
      textNode = $('<div>');
      textNode.attr('rv-text', "" + ITEM_NAME + ":text");
      optionNode.wrap(labelNode);
      optionNode.parent().wrap(repeatingElement);
      return textNode.insertAfter(optionNode);
    };

    RadioButton.prototype.getModelData = function() {
      var data;
      data = {};
      data["model" + this.cid] = this.model;
      data["collection" + this.cid] = this.collection;
      return data;
    };


    /*
      Return the option dom elements
     */

    RadioButton.prototype.getDomNodes = function() {
      return Backbone.Marionette.Component.Component.prototype.getDomNode.call(this, arguments);
    };


    /*
      Unsupported for this component, as more than one dom node can be returned.
     */

    RadioButton.prototype.getDomNode = function() {
      throw new Error('Unsupported Method, use getDomNodes() instead.');
    };

    return RadioButton;

  })(Backbone.Marionette.Component.Component);
  (_base = Backbone.Marionette).Component || (_base.Component = {});
  return (_base1 = Backbone.Marionette.Component).RadioButton || (_base1.RadioButton = RadioButton);
});

//# sourceMappingURL=RadioButton.js.map
;
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define('lib/component/form/TextArea',['lib/component/Component'], function() {
  
  var TextArea, _base, _base1;
  TextArea = (function(_super) {
    __extends(TextArea, _super);

    function TextArea(componentId, property, model) {
      this.componentId = componentId;
      this.property = property;
      this.model = model;
      if (!this.model) {
        throw new Error("model needs to be specified");
      }
      TextArea.__super__.constructor.call(this, this.componentId, this.model);
    }

    TextArea.prototype.render = function() {
      var domNode;
      domNode = this.getDomNode();
      return domNode.attr('rv-value', "" + this.cid + ":" + this.property);
    };

    return TextArea;

  })(Backbone.Marionette.Component.Component);
  (_base = Backbone.Marionette).Component || (_base.Component = {});
  return (_base1 = Backbone.Marionette.Component).TextArea || (_base1.TextArea = TextArea);
});

//# sourceMappingURL=TextArea.js.map
;
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define('lib/component/form/TextField',['lib/component/Component'], function() {
  
  var TextField, _base, _base1;
  TextField = (function(_super) {
    var defaultInputType;

    __extends(TextField, _super);

    defaultInputType = 'text';

    function TextField(componentId, property, model) {
      this.componentId = componentId;
      this.property = property;
      this.model = model;
      if (!this.model) {
        throw new Error("model needs to be specified");
      }
      TextField.__super__.constructor.call(this, this.componentId, this.model);
    }

    TextField.prototype.render = function() {
      var domNode;
      domNode = this.getDomNode();
      if (!domNode.attr('type')) {
        domNode.attr('type', this.inputType || defaultInputType);
      }
      return domNode.attr('rv-value', "" + this.cid + ":" + this.property);
    };

    return TextField;

  })(Backbone.Marionette.Component.Component);
  (_base = Backbone.Marionette).Component || (_base.Component = {});
  return (_base1 = Backbone.Marionette.Component).TextField || (_base1.TextField = TextField);
});

//# sourceMappingURL=TextField.js.map
;
define('lib/component/generics/Map',[], function() {
  
  var Map, mapMethods, _base, _base1;
  Map = (function() {
    function Map() {
      this._entries = {};
    }

    Map.prototype.put = function(key, object) {
      if (!this.has(key)) {
        return this._entries[key] = object;
      }
    };

    Map.prototype.get = function(key) {
      return this._entries[key];
    };

    Map.prototype.remove = function(key) {
      return delete this._entries[key];
    };

    Map.prototype.clear = function() {
      return this._entries = {};
    };

    Map.prototype.size = function() {
      return this.keys().length;
    };

    return Map;

  })();
  mapMethods = ['values', 'keys', 'has', 'each', 'isEmpty'];
  _.each(mapMethods, function(method) {
    return Map.prototype[method] = function() {
      var args;
      args = [].slice.call(arguments);
      args.unshift(this._entries);
      return _[method].apply(_, args);
    };
  });
  (_base = Backbone.Marionette).Component || (_base.Component = {});
  return (_base1 = Backbone.Marionette.Component).Map || (_base1.Map = Map);
});

//# sourceMappingURL=Map.js.map
;
var __slice = [].slice;

define('lib/component/utils/ComponentStore',['lib/component/Component', 'lib/component/generics/Map'], function() {
  
  var ComponentStore, _base, _base1;
  ComponentStore = (function() {
    function ComponentStore() {
      this._components = new Backbone.Marionette.Component.Map;
    }


    /*
      Adds a component to the storage
     */

    ComponentStore.prototype.add = function() {
      var component, components, _i, _len, _results;
      components = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      _results = [];
      for (_i = 0, _len = components.length; _i < _len; _i++) {
        component = components[_i];
        if (!(component instanceof Backbone.Marionette.Component.Component)) {
          throw new Error("" + component.constructor.name + " has to be an instance of Component");
        }
        if (this._components.has(component.getComponentId())) {
          throw new Error("" + (component.getComponentId()) + " has already been added");
        }
        _results.push(this._components.put(component.getComponentId(), component));
      }
      return _results;
    };


    /*
      Removes a component from the storage
     */

    ComponentStore.prototype.remove = function(component) {
      return this._components.remove(component.getComponentId());
    };

    ComponentStore.prototype.contains = function(component) {
      return this._components.has(component.getComponentId());
    };

    ComponentStore.prototype.each = function(callback) {
      return this._components.each(function(component) {
        return callback.call(this, component);
      });
    };

    return ComponentStore;

  })();
  (_base = Backbone.Marionette).Component || (_base.Component = {});
  return (_base1 = Backbone.Marionette.Component).ComponentStore || (_base1.ComponentStore = ComponentStore);
});

//# sourceMappingURL=ComponentStore.js.map
;
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __slice = [].slice;

define('lib/component/Form',['lib/component/Component', 'lib/component/utils/ComponentStore'], function() {
  
  var Form, _base, _base1;
  Form = (function(_super) {
    __extends(Form, _super);

    function Form(componentId, options) {
      this.componentId = componentId;
      if (options == null) {
        options = {};
      }
      Form.__super__.constructor.apply(this, arguments);
      this.onSubmit = options.onSubmit, this.onError = options.onError;
      this._componentStore = new Backbone.Marionette.Component.ComponentStore;
    }

    Form.prototype.setViewInstance = function(viewInstance) {
      Form.__super__.setViewInstance.apply(this, arguments);
      return this._componentStore.each(function(component) {
        return component.setViewInstance(viewInstance);
      });
    };

    Form.prototype.getModelData = function() {
      var data;
      data = {};
      this._componentStore.each(function(component) {
        return data = _.extend(data, component.getModelData());
      });
      return data;
    };

    Form.prototype.add = function() {
      var component, components, _i, _len, _results;
      components = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this._componentStore.add.apply(this._componentStore, components);
      _results = [];
      for (_i = 0, _len = components.length; _i < _len; _i++) {
        component = components[_i];
        _results.push(component.setParent(this));
      }
      return _results;
    };

    Form.prototype.contains = function(component) {
      return this._componentStore.contains.call(this._componentStore, component);
    };

    Form.prototype.remove = function(component) {
      return this._componentStore.remove.call(this._componentStore, component);
    };

    Form.prototype.render = function() {
      var form;
      this._componentStore.each(function(component) {
        return component.render();
      });
      form = this.getDomNode();
      return form.on('submit', (function(_this) {
        return function(event) {
          return _this.process.call(_this, event);
        };
      })(this));
    };

    Form.prototype.close = function() {
      var form;
      this._componentStore.each(function(component) {
        return component.close();
      });
      form = this.getDomNode();
      return form.off('submit');
    };

    Form.prototype.destroy = function() {
      return this._componentStore.each(function(component) {
        return component.destroy();
      });
    };


    /*
      Validate all nested components
     */

    Form.prototype.process = function(event) {
      var feedbackList;
      event.preventDefault();
      feedbackList = this.getParent().getFeedbackList();
      feedbackList.reset();
      this._componentStore.each(function(component) {
        component.validate();
        return feedbackList.add(component.getValidationErrors());
      });
      if (feedbackList.length) {
        return this.triggerMethod('error', feedbackList);
      } else {
        return this.triggerMethod('submit');
      }
    };

    return Form;

  })(Backbone.Marionette.Component.Component);
  (_base = Backbone.Marionette).Component || (_base.Component = {});
  return (_base1 = Backbone.Marionette.Component).Form || (_base1.Form = Form);
});

//# sourceMappingURL=Form.js.map
;
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define('lib/component/panel/BasePanel',['lib/component/Component'], function() {
  
  var BasePanel, _base, _base1;
  BasePanel = (function(_super) {
    __extends(BasePanel, _super);

    function BasePanel() {
      return BasePanel.__super__.constructor.apply(this, arguments);
    }

    return BasePanel;

  })(Backbone.Marionette.Component.Component);
  (_base = Backbone.Marionette).Component || (_base.Component = {});
  return (_base1 = Backbone.Marionette.Component).BasePanel || (_base1.BasePanel = BasePanel);
});

//# sourceMappingURL=BasePanel.js.map
;
define('lib/component/adapter/rivets',['rivets'], function(rivets) {
  

  /*
  Backbone Adapter
  
  @type {{
    observer: observer,
    unobserve: unobserve,
    get: get,
    set: set
  }}
   */
  var UNSUPPORTED_OBJECT_MESSAGE;
  UNSUPPORTED_OBJECT_MESSAGE = 'object not supported for rv-adapter ":"';
  rivets.adapters[":"] = {
    observe: function(obj, keypath, callback) {
      if (obj instanceof Backbone.Model) {
        obj.on('change:' + keypath, callback);
      } else if (obj instanceof Backbone.Collection) {
        obj.on('add remove reset', callback);
      } else {
        throw new Error(UNSUPPORTED_OBJECT_MESSAGE);
      }
    },
    unobserve: function(obj, keypath, callback) {
      if (obj instanceof Backbone.Model) {
        obj.off('change:' + keypath, callback);
      } else if (obj instanceof Backbone.Collection) {
        obj.off('add remove reset', callback);
      } else {
        throw new Error(UNSUPPORTED_OBJECT_MESSAGE);
      }
    },
    get: function(obj, keypath) {
      if (obj instanceof Backbone.Model) {
        return obj.get(keypath);
      } else if (obj instanceof Backbone.Collection) {
        return obj[keypath];
      } else {
        throw new Error(UNSUPPORTED_OBJECT_MESSAGE);
      }
    },
    set: function(obj, keypath, value) {
      if (obj instanceof Backbone.Model) {
        obj.set(keypath, value);
      } else if (obj instanceof Backbone.Collection) {
        obj[keypath] = value;
      } else {
        throw new Error(UNSUPPORTED_OBJECT_MESSAGE);
      }
    }
  };
  return rivets;
});

//# sourceMappingURL=rivets.js.map
;
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __slice = [].slice;

define('lib/component/ItemView',['lib/component/utils/ComponentStore', 'lib/component/panel/BasePanel', 'lib/component/adapter/rivets'], function() {
  
  var ItemView, _base, _base1;
  ItemView = (function(_super) {
    __extends(ItemView, _super);

    function ItemView() {
      this._componentStore = new Backbone.Marionette.Component.ComponentStore;
      this._feedbackList = new Backbone.Collection;
      ItemView.__super__.constructor.apply(this, arguments);
    }

    ItemView.prototype.getFeedbackList = function() {
      return this._feedbackList;
    };

    ItemView.prototype.add = function() {
      var component, components, _i, _len, _results;
      components = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this._componentStore.add.apply(this._componentStore, components);
      _results = [];
      for (_i = 0, _len = components.length; _i < _len; _i++) {
        component = components[_i];
        component.setParent(this);
        component.setViewInstance(this);
        if (component instanceof Backbone.Marionette.Component.BasePanel) {
          _results.push(component.setFeedbackList(this._feedbackList));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    ItemView.prototype.contains = function(component) {
      return this._componentStore.contains(component);
    };

    ItemView.prototype.removeComponent = function(component) {
      return this._componentStore.remove(component);
    };


    /*
      Binding the model data to the view instance
     */

    ItemView.prototype.render = function() {
      var data;
      ItemView.__super__.render.apply(this, arguments);
      data = {};
      this._componentStore.each(function(component) {
        return component.render();
      });
      this._componentStore.each(function(component) {
        return data = _.extend(data, component.getModelData());
      });
      return this.rivetsView = rivets.bind(this.$el, data);
    };


    /*
      Unbind rivetsView when component is closed
     */

    ItemView.prototype.close = function() {
      this._componentStore.each(function(component) {
        return component.close();
      });
      if (this.rivetsView) {
        return this.rivetsView.unbind();
      }
    };


    /*
      Destroy components
     */

    ItemView.prototype.destroy = function() {
      this._componentStore.each(function(component) {
        return component.destroy();
      });
      return ItemView.__super__.destroy.apply(this, arguments);
    };

    return ItemView;

  })(Backbone.Marionette.ItemView);
  (_base = Backbone.Marionette).Component || (_base.Component = {});
  return (_base1 = Backbone.Marionette.Component).ItemView || (_base1.ItemView = ItemView);
});

//# sourceMappingURL=ItemView.js.map
;
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define('lib/component/markup/Label',['lib/component/Component'], function() {
  
  var Label, _base, _base1;
  Label = (function(_super) {
    __extends(Label, _super);

    function Label(componentId, value, model) {
      this.componentId = componentId;
      this.value = value;
      this.model = model;
      Label.__super__.constructor.call(this, this.componentId, this.model);
    }

    Label.prototype.render = function() {
      if (this.model) {
        return this.getDomNode().attr('rv-text', "" + this.cid + ":" + this.value);
      } else {
        return this.getDomNode().text(this.value);
      }
    };

    return Label;

  })(Backbone.Marionette.Component.Component);
  (_base = Backbone.Marionette).Component || (_base.Component = {});
  return (_base1 = Backbone.Marionette.Component).Label || (_base1.Label = Label);
});

//# sourceMappingURL=Label.js.map
;
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define('lib/component/utils/FilteredCollection',[], function() {
  
  var FilteredCollection, _base, _base1;
  FilteredCollection = (function(_super) {
    var inducedOrdering;

    __extends(FilteredCollection, _super);

    function FilteredCollection(underlying, options) {
      if (options == null) {
        options = {};
      }
      this.underlying = underlying;
      this.model = underlying.model;
      this.comparator = options.comparator || inducedOrdering(underlying);
      this.options = _.extend({}, underlying.options, options);
      FilteredCollection.__super__.constructor.call(this, this.underlying.models.filter(this.options.filter), options);
      this.listenTo(this.underlying, {
        reset: (function(_this) {
          return function() {
            return _this.reset(_this.underlying.models.filter(_this.options.filter));
          };
        })(this),
        remove: (function(_this) {
          return function(model) {
            if (_this.contains(model)) {
              return _this.remove(model);
            }
          };
        })(this),
        add: (function(_this) {
          return function(model) {
            if (_this.options.filter(model)) {
              return _this.add(model);
            }
          };
        })(this),
        change: (function(_this) {
          return function(model) {
            return _this.decideOn(model);
          };
        })(this),
        sort: (function(_this) {
          return function() {
            if (_this.comparator.induced) {
              return _this.sort();
            }
          };
        })(this)
      });
    }

    FilteredCollection.prototype.update = function() {
      var model, _i, _len, _ref, _results;
      _ref = this.underlying.models;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        model = _ref[_i];
        _results.push(this.decideOn(model));
      }
      return _results;
    };

    FilteredCollection.prototype.decideOn = function(model) {
      if (this.contains(model)) {
        if (!this.options.filter(model)) {
          return this.remove(model);
        }
      } else {
        if (this.options.filter(model)) {
          return this.add(model);
        }
      }
    };

    inducedOrdering = function(collection) {
      var func;
      func = function(model) {
        return collection.indexOf(model);
      };
      func.induced = true;
      return func;
    };

    return FilteredCollection;

  })(Backbone.Collection);
  (_base = Backbone.Marionette).Component || (_base.Component = {});
  return (_base1 = Backbone.Marionette.Component).FilteredCollection || (_base1.FilteredCollection = FilteredCollection);
});

//# sourceMappingURL=FilteredCollection.js.map
;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define('lib/component/panel/FeedbackPanel',['lib/component/panel/BasePanel', 'lib/component/utils/FilteredCollection'], function() {
  
  var FeedbackPanel, _base, _base1;
  FeedbackPanel = (function(_super) {
    __extends(FeedbackPanel, _super);

    function FeedbackPanel(componentId, filter) {
      this.componentId = componentId;
      this.filter = filter;
      this.componentFilter = __bind(this.componentFilter, this);
      FeedbackPanel.__super__.constructor.apply(this, arguments);
    }

    FeedbackPanel.prototype.setFeedbackList = function(collection) {
      if (this.filter) {
        return this._feedbackList = new Backbone.Marionette.Component.FilteredCollection(collection, {
          filter: this.componentFilter
        });
      } else {
        return this._feedbackList = collection;
      }
    };

    FeedbackPanel.prototype.componentFilter = function(validationError) {
      return validationError.getComponentId() === this.filter.getComponentId();
    };

    FeedbackPanel.prototype.render = function() {
      var ITEM_NAME, listNode, panelNode, repeatingElement;
      ITEM_NAME = 'feedback';
      repeatingElement = $('<li>');
      repeatingElement.attr("rv-each-" + ITEM_NAME, "collection" + this.cid + ":models");
      repeatingElement.attr("rv-text", "" + ITEM_NAME + ":errorMessage");
      listNode = $('<ul>');
      listNode.append(repeatingElement);
      panelNode = this.getDomNode();
      panelNode.attr('rv-show', "collection" + this.cid + ":length");
      return panelNode.append(listNode);
    };

    FeedbackPanel.prototype.getModelData = function() {
      var data;
      data = {};
      data["collection" + this.cid] = this._feedbackList;
      return data;
    };

    FeedbackPanel.prototype.destroy = function() {
      delete this.filter;
      return delete this._feedbackList;
    };

    return FeedbackPanel;

  })(Backbone.Marionette.Component.BasePanel);
  (_base = Backbone.Marionette).Component || (_base.Component = {});
  return (_base1 = Backbone.Marionette.Component).FeedbackPanel || (_base1.FeedbackPanel = FeedbackPanel);
});

//# sourceMappingURL=FeedbackPanel.js.map
;
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define('lib/component/validation/validator/PatternValidator',['lib/component/validation/validator/BaseValidator', 'lib/component/validation/ValidationError'], function() {
  
  var PatternValidator, _base, _base1;
  PatternValidator = (function(_super) {
    __extends(PatternValidator, _super);

    PatternValidator.prototype.NAME = 'PatternValidator';

    function PatternValidator(pattern, mode) {
      this.pattern = pattern;
      this.mode = mode != null ? mode : 'ig';
    }

    PatternValidator.prototype.validate = function(component) {
      var options, properties, regex, value;
      value = component.getValue();
      regex = new RegExp(this.pattern, this.mode);
      if (!(regex.test(value))) {
        options = {
          validatorName: this.NAME,
          validationName: 'pattern',
          componentId: component.getComponentId()
        };
        properties = {
          pattern: this.pattern,
          value: value
        };
        return component.add(new Backbone.Marionette.Component.ValidationError(properties, options));
      }
    };

    return PatternValidator;

  })(Backbone.Marionette.Component.BaseValidator);
  (_base = Backbone.Marionette).Component || (_base.Component = {});
  return (_base1 = Backbone.Marionette.Component).PatternValidator || (_base1.PatternValidator = PatternValidator);
});

//# sourceMappingURL=PatternValidator.js.map
;
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define('lib/component/validation/validator/EmailAddressValidator',['lib/component/validation/validator/PatternValidator'], function() {
  
  var EmailAddressValidator, _base, _base1;
  EmailAddressValidator = (function(_super) {
    __extends(EmailAddressValidator, _super);

    EmailAddressValidator.prototype.NAME = 'EmailAddressValidator';

    function EmailAddressValidator() {
      EmailAddressValidator.__super__.constructor.call(this, '^[_A-Za-z0-9-]+(\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*((\.[A-Za-z]{2,}){1}$)', 'ig');
    }

    return EmailAddressValidator;

  })(Backbone.Marionette.Component.PatternValidator);
  (_base = Backbone.Marionette).Component || (_base.Component = {});
  return (_base1 = Backbone.Marionette.Component).EmailAddressValidator || (_base1.EmailAddressValidator = EmailAddressValidator);
});

//# sourceMappingURL=EmailAddressValidator.js.map
;
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define('lib/component/validation/validator/StringValidator',['lib/component/validation/validator/BaseValidator', 'lib/component/validation/ValidationError'], function() {
  
  var StringValidator, _base, _base1;
  StringValidator = (function(_super) {
    __extends(StringValidator, _super);

    StringValidator.prototype.NAME = 'StringValidator';

    function StringValidator(minimum, maximum, validationName) {
      this.minimum = minimum != null ? minimum : null;
      this.maximum = maximum != null ? maximum : null;
      this.validationName = validationName;
    }

    StringValidator.prototype.validate = function(component) {
      var error, options, value;
      value = component.getValue();
      if ((this.minimum && this.minimum > (value != null ? value.length : void 0)) || (this.maximum && this.maximum < (value != null ? value.length : void 0))) {
        options = {
          validationName: this.validationName,
          validatorName: this.NAME,
          componentId: component.getComponentId()
        };
        error = new Backbone.Marionette.Component.ValidationError({
          value: value
        }, options);
        if (this.minimum) {
          error.set('minimum', this.minimum);
        }
        if (this.maximum) {
          error.set('maximum', this.maximum);
        }
        return component.add(error);
      }
    };

    StringValidator.prototype.onComponentTag = function(component, tag) {
      if (!tag.attr('minlength')) {
        tag.attr('minlength', this.minimum);
      }
      if (!tag.attr('maxlength')) {
        return tag.attr('maxlength', this.maximum);
      }
    };

    StringValidator.prototype.exactLength = function(length) {
      return new Backbone.Marionette.Component.StringValidator(length, length, 'exactLength');
    };

    StringValidator.prototype.maximumLength = function(length) {
      return new Backbone.Marionette.Component.StringValidator(null, length, 'maximumLength');
    };

    StringValidator.prototype.minimumLength = function(length) {
      return new Backbone.Marionette.Component.StringValidator(length, null, 'minimumLength');
    };

    StringValidator.prototype.lengthBetween = function(minimum, maximum) {
      return new Backbone.Marionette.Component.StringValidator(minimum, maximum, 'between');
    };

    return StringValidator;

  })(Backbone.Marionette.Component.BaseValidator);
  (_base = Backbone.Marionette).Component || (_base.Component = {});
  return (_base1 = Backbone.Marionette.Component).StringValidator || (_base1.StringValidator = StringValidator);
});

//# sourceMappingURL=StringValidator.js.map
;
define('lib/bundle',['lib/component/Component', 'lib/component/form/Button', 'lib/component/form/Checkbox', 'lib/component/form/Dropdown', 'lib/component/form/RadioButton', 'lib/component/form/TextArea', 'lib/component/form/TextField', 'lib/component/Form', 'lib/component/generics/Map', 'lib/component/ItemView', 'lib/component/markup/Label', 'lib/component/panel/BasePanel', 'lib/component/panel/FeedbackPanel', 'lib/component/utils/ComponentStore', 'lib/component/utils/FilteredCollection', 'lib/component/utils/InstanceCounter', 'lib/component/validation/ValidationError', 'lib/component/validation/validator/BaseValidator', 'lib/component/validation/validator/EmailAddressValidator', 'lib/component/validation/validator/PatternValidator', 'lib/component/validation/validator/StringValidator'], function(Component) {
  
  return window.Backbone.Marionette.Component = Backbone.Marionette.Component;
});

//# sourceMappingURL=bundle.js.map
;
