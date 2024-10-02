{{- define "doriscluster.name" -}}
{{ default .Chart.Name .Values.dorisCluster.name }}
{{- end }}

{{- define "doriscluster.namespace" -}}
{{ print .Release.Namespace }}
{{- end }}

{{- define "kube-control.name" -}}
{{- print "doris-operator" }}
{{- end }}

{{/*
doris cluster pod default resource.
*/}}
{{- define "doriscluster.default.resource" }}
    requests:
      cpu: 8
      memory: 16Gi
    limits:
      cpu: 16
      memory: 32Gi
{{- end }}


{{/*
doris cluster admin user and password secret name.
*/}}
{{- define "doriscluster.secret.name" -}}
    {{ template "doriscluster.name" . }}-secret-base64
{{- end -}}

{{/*
doris cluster fe configMap default name.
*/}}
{{- define "doriscluster.default.feConfigMap.name" -}}
    {{ template "doriscluster.name" . }}-fe-configmap
{{- end -}}

{{/*
doris cluster fe pod default configMap resolve file.
*/}}
{{- define "doriscluster.default.feConfig.resolveKey" }}
{{- print "fe.conf" }}
{{- end }}

{{/*
doris cluster be configMap default name.
*/}}
{{- define "doriscluster.default.beConfigMap.name" -}}
    {{ template "doriscluster.name" . }}-be-configmap
{{- end -}}

{{/*
doris cluster pod default configMap resolve file.
*/}}
{{- define "doriscluster.default.beConfig.resolveKey" }}
{{- print "be.conf" }}
{{- end }}

{{/*
doris cluster cn  configMap default name.
*/}}
{{- define "doriscluster.default.cnConfigMap.name" -}}
    {{ template "doriscluster.name" . }}-cn-configmap
{{- end -}}

{{/*
doris cluster cn pod default configMap resolve file.
*/}}
{{- define "doriscluster.default.cnConfig.resolveKey" }}
{{- print "be.conf" }}
{{- end }}

{{/*
doris cluster broker configMap default name.
*/}}
{{- define "doriscluster.default.brokerConfigMap.name" -}}
    {{ template "doriscluster.name" . }}-broker-configmap
{{- end -}}

{{/*
doris cluster broker pod default configMap resolve file.
*/}}
{{- define "doriscluster.default.brokerConfig.resolveKey" }}
{{- print "apache_hdfs_broker.conf" }}
{{- end }}

{{/*
doris cluster cn pod autoscaler default version.
*/}}
{{- define "doriscluster.default.autoScalerVersion" -}}
{{- print "v2" }}
{{- end -}}

{{/*
doris cluster fe PVC
*/}}
{{- define "doriscluster.fe.pvc" -}}

    {{- if .Values.feSpec.persistentVolumeClaim.metaPersistentVolume}}
    - mountPath: /opt/apache-doris/fe/doris-meta
      name: fe-meta
      persistentVolumeClaimSpec:
        storageClassName: {{ .Values.feSpec.persistentVolumeClaim.metaPersistentVolume.storageClassName }}
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: {{ .Values.feSpec.persistentVolumeClaim.metaPersistentVolume.storage}}
    {{- end }}
    {{- if .Values.feSpec.persistentVolumeClaim.logsPersistentVolume}}
    - mountPath: /opt/apache-doris/fe/log
      name: fe-log
      persistentVolumeClaimSpec:
        storageClassName: {{ .Values.feSpec.persistentVolumeClaim.logsPersistentVolume.storageClassName }}
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: {{ .Values.feSpec.persistentVolumeClaim.logsPersistentVolume.storage}}
    {{- end }}
    {{- if .Values.feSpec.persistentVolumeClaim.jdbcDriversPersistentVolume}}
    - mountPath: /opt/apache-doris/fe/jdbc_drivers
      name: fe-jdbc-drivers
      persistentVolumeClaimSpec:
        storageClassName: {{ .Values.feSpec.persistentVolumeClaim.jdbcDriversPersistentVolume.storageClassName }}
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: {{ .Values.feSpec.persistentVolumeClaim.jdbcDriversPersistentVolume.storage}}
    {{- end }}
{{- end -}}


{{/*
doris cluster be PVC
*/}}
{{- define "doriscluster.be.pvc" -}}

    {{- range .Values.beSpec.dataPersistentVolumeClaim }}
    - mountPath: {{ .mountPath }}
      name: {{ .name }}
      persistentVolumeClaimSpec:
        storageClassName: {{ .storageClassName }}
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: {{ .storage }}
    {{- end }}
    {{- if and .Values.beSpec.persistentVolumeClaim.logsPersistentVolume .Values.beSpec.persistentVolumeClaim.logsPersistentVolume.storage}}
    - mountPath: /opt/apache-doris/be/log
      name: be-log
      persistentVolumeClaimSpec:
        {{- if .Values.beSpec.persistentVolumeClaim.logsPersistentVolume.storageClassName }}
        storageClassName: {{ .Values.beSpec.persistentVolumeClaim.logsPersistentVolume.storageClassName }}
        {{- end }}
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: {{ .Values.beSpec.persistentVolumeClaim.logsPersistentVolume.storage}}
    {{- end }}
    {{- if .Values.beSpec.persistentVolumeClaim.jdbcDriversPersistentVolume}}
    - mountPath: /opt/apache-doris/be/jdbc_drivers
      name: be-jdbc-drivers
      persistentVolumeClaimSpec:
        storageClassName: {{ .Values.feSpec.persistentVolumeClaim.jdbcDriversPersistentVolume.storageClassName }}
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: {{ .Values.feSpec.persistentVolumeClaim.jdbcDriversPersistentVolume.storage}}
    {{- end }}
{{- end -}}


{{/*
doris cluster cn PVC
*/}}
{{- define "doriscluster.cn.pvc" -}}

    {{- if and .Values.cnSpec.persistentVolumeClaim.dataPersistentVolume .Values.cnSpec.persistentVolumeClaim.dataPersistentVolume.storage}}
    - mountPath: /opt/apache-doris/be/storage
      name: cn-storage
      persistentVolumeClaimSpec:
        {{- if or .Values.cnSpec.persistentVolumeClaim.dataPersistentVolume.storageClassName .Values.cnSpec.persistentVolumeClaim.logsPersistentVolume.storageClassName }}
        storageClassName: {{ default .Values.cnSpec.persistentVolumeClaim.logsPersistentVolume.storageClassName .Values.cnSpec.persistentVolumeClaim.dataPersistentVolume.storageClassName }}
        {{- end }}
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: {{ .Values.cnSpec.persistentVolumeClaim.dataPersistentVolume.storage}}
    {{- end }}
    {{- if and .Values.cnSpec.persistentVolumeClaim.logsPersistentVolume .Values.cnSpec.persistentVolumeClaim.logsPersistentVolume.storage}}
    - mountPath: /opt/apache-doris/be/log
      name: cn-log
      persistentVolumeClaimSpec:
        {{- if or .Values.cnSpec.persistentVolumeClaim.dataPersistentVolume.storageClassName .Values.cnSpec.persistentVolumeClaim.logsPersistentVolume.storageClassName }}
        storageClassName: {{ default .Values.cnSpec.persistentVolumeClaim.dataPersistentVolume.storageClassName .Values.cnSpec.persistentVolumeClaim.logsPersistentVolume.storageClassName }}
        {{- end }}
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: {{ .Values.cnSpec.persistentVolumeClaim.logsPersistentVolume.storage}}
    {{- end }}
{{- end -}}



{{/*
doris cluster broker PVC
*/}}
{{- define "doriscluster.broker.pvc" -}}
    {{- if and .Values.brokerSpec.persistentVolumeClaim.logsPersistentVolume .Values.brokerSpec.persistentVolumeClaim.logsPersistentVolume.storage}}
    - mountPath: /opt/apache-doris/apache_hdfs_broker/log
      name: broker-log
      persistentVolumeClaimSpec:
        {{- if .Values.brokerSpec.persistentVolumeClaim.logsPersistentVolume.storageClassName}}
        storageClassName: {{ .Values.brokerSpec.persistentVolumeClaim.logsPersistentVolume.storageClassName }}
        {{- end }}
        accessModes:
        - ReadWriteOnce
        resources:
          requests:
            storage: {{ .Values.brokerSpec.persistentVolumeClaim.logsPersistentVolume.storage}}
    {{- end }}
{{- end -}}


{{- define "doriscluster.feConfig.configMaps" }}
    {{- range .Values.feSpec.configMap.mountConfigMaps }}
        - configMapName: {{ .configMapName }}
          mountPath: {{ .mountPath }}
    {{- end }}
{{- end }}


{{- define "doriscluster.beConfig.configMaps" }}
    {{- range .Values.beSpec.configMap.mountConfigMaps }}
        - configMapName: {{ .configMapName }}
          mountPath: {{ .mountPath }}
    {{- end }}
{{- end }}


{{- define "doriscluster.cnConfig.configMaps" }}
    {{- range .Values.cnSpec.configMap.mountConfigMaps }}
        - configMapName: {{ .configMapName }}
          mountPath: {{ .mountPath }}
    {{- end }}
{{- end }}


{{- define "doriscluster.brokerConfig.configMaps" }}
    {{- range .Values.brokerSpec.configMap.mountConfigMaps }}
        - configMapName: {{ .configMapName }}
          mountPath: {{ .mountPath }}
    {{- end }}
{{- end }}
