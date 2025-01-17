CREATE TABLE `elecmeterTodatahouseNotDurQueueMsg_244` (
  `deviceName` varchar(*) COMMENT '设备编号',
  `ts` varchar(*) COMMENT '当前毫秒时间戳',
  `Ia` DECIMAL(10, 2) COMMENT 'A相电流',
  `Ib` DECIMAL(10, 2) COMMENT 'B相电流',
  `Ic` DECIMAL(10, 2) COMMENT 'C相电流',
  `Ua` DECIMAL(10, 2) COMMENT 'A相电压',
  `Ub` DECIMAL(10, 2) COMMENT 'B相电压',
  `Uc` DECIMAL(10, 2) COMMENT 'C相电压',
  `Uab` DECIMAL(10, 2) COMMENT '线电压Uab',
  `Ubc` DECIMAL(10, 2) COMMENT '线电压Uac',
  `Uac` DECIMAL(10, 2) COMMENT '线电压Ubc',
  `frequency` DECIMAL(10, 2) COMMENT '频率',
  `Pa` DECIMAL(10, 2) COMMENT 'A相有功功率',
  `Pb` DECIMAL(10, 2) COMMENT 'B相有功功率',
  `Pc` DECIMAL(10, 2) COMMENT 'C相有功功率',
  `Psum` DECIMAL(10, 2) COMMENT '总有功功率',
  `Qa` DECIMAL(10, 2) COMMENT 'A相无功功率',
  `Qb` DECIMAL(10, 2) COMMENT 'B相无功功率',
  `Qc` DECIMAL(10, 2) COMMENT 'C相无功功率',
  `Qsum` DECIMAL(10, 2)COMMENT '总无功功率',
  `Sa` DECIMAL(10, 2) COMMENT 'A相视在功率',
  `Sb` DECIMAL(10, 2) COMMENT 'B相视在功率',
  `Sc` DECIMAL(10, 2) COMMENT 'C相视在功率',
  `Ssum` DECIMAL(10, 2) COMMENT '总视在功率',
  `PFa` DECIMAL(10, 3) COMMENT 'A功率因素',
  `PFb` DECIMAL(10, 3) COMMENT 'B功率因素',
  `PFc` DECIMAL(10, 3) COMMENT 'C功率因素',
  `PFsum` DECIMAL(10, 3) COMMENT '总功率因素',
  `Uib` DECIMAL(10, 3) COMMENT '电压不平衡度',
  `Iib` DECIMAL(10, 3) COMMENT '电流不平衡度',
  `activeTotalElectricalEnergy` int(11) COMMENT '当前组合有功总电能',
  `PT` int(11) COMMENT '电压变比',
  `CT` int(11) COMMENT '电流变比',
  `positiveActiveTotalElectricalEnergy` int(11) COMMENT '正向有功总电能',
  `totalReverseActiveEnergy` int(11) COMMENT '反向有功总电能',
  `activeTotalElectricalEnergy48List` ARRAY<DOUBLE> NULL COMMENT '当前组合有功总电能',
  `positiveActiveTotalElectricalEnergy48List` ARRAY<DOUBLE> NULL COMMENT '正向有功总电能',
  `totalReverseActiveEnergy48List` ARRAY<DOUBLE> NULL COMMENT '反向有功总电能'
) ENGINE = OLAP DUPLICATE KEY(`deviceName`, `ts`, `Ia`) COMMENT 'OLAP' DISTRIBUTED BY HASH(`deviceName`) BUCKETS 32 PROPERTIES (
  "replication_allocation" = "tag.location.default: 1",
  "is_being_synced" = "false",
  "storage_format" = "V2",
  "light_schema_change" = "true",
  "disable_auto_compaction" = "false",
  "enable_single_replica_compaction" = "false"
);
