{{/*
Expand the name of the chart.
*/}}
{{- define "rancher-cloud.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "rancher-cloud.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "rancher-cloud.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "rancher-cloud.labels" -}}
helm.sh/chart: {{ include "rancher-cloud.chart" . }}
{{ include "rancher-cloud.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "rancher-cloud.selectorLabels" -}}
app.kubernetes.io/name: {{ include "rancher-cloud.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "rancher-cloud.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "rancher-cloud.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Check for Rancher image configuration
*/}}
{{- define "rancher-cloud.image" -}}
  {{- if and (.Values.global) (.Values.global.azure) (.Values.global.azure.images) }}
    {{- .Values.global.azure.images.rancher_cloud.registry }}/{{ .Values.global.azure.images.rancher_cloud.image }}@{{ .Values.global.azure.images.rancher_cloud.digest }}
  {{- else if and (.Values.global) (.Values.global.csp) (.Values.global.csp.images) }}
    {{- .Values.global.csp.images.rancher_cloud.registry }}/{{ .Values.global.csp.images.rancher_cloud.image }}{{- if .Values.global.csp.images.rancher_cloud.digest }}@{{ .Values.global.csp.images.rancher_cloud.digest }}{{- else }}:{{ .Values.global.csp.images.rancher_cloud.tag }}{{- end }}
  {{- else }}
    {{- .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}
  {{- end }}
{{- end }}
