import jenkins.model.Jenkins
import hudson.model.*

// 获取 Jenkins 实例
def jenkins = Jenkins.getInstance()

// 定义视图名称
def sourceViewName = 'V2.1.0.20240530'
def targetViewName = 'V2.1.0.20240930'

// 获取源视图对象
def sourceView = jenkins.getView(sourceViewName)
if (sourceView == null) {
    throw new IllegalArgumentException("Source view not found: ${sourceViewName}")
}

// 获取目标视图对象
def targetView = jenkins.getView(targetViewName)
if (targetView == null) {
    throw new IllegalArgumentException("Target view not found: ${targetViewName}")
}

// 定义需要复制的任务前缀
def jobPrefix = '安装拉包V2.1.0.20240530'

// 循环处理源视图下的任务
sourceView.getItems().each { job ->
    if (job instanceof hudson.model.Job && job.name.startsWith(jobPrefix)) {
        def newJobName = job.name.replaceFirst(jobPrefix, '安装拉包V2.1.0.20240930')
        println("Copying job ${job.name} to ${targetViewName}/${newJobName}")

        // 使用 Jenkins 的 API 复制任务
        jenkins.copy(job, newJobName)

        // 如果需要，也可以将新任务添加到目标视图中
        def newJob = jenkins.getItemByFullName(newJobName, hudson.model.Job.class)
        if (newJob != null && targetView instanceof hudson.model.ListView) {
            targetView.add(newJob)
        }
    }
}