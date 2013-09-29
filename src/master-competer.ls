(require, config) <- define ['require', 'config']
key = config.local-stroage-master-competion-key
heart-beat-interval = config.at-plus-master-heart-beat-interval
exports =
  compete-master = !(local-storage, callback)->

