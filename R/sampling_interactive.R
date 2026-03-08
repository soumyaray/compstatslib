#' compstatslib interactive_sampling() function
#'
#' Interactive visualization to sample from a population and see how a given
#' sampling statistic (theta) is distributed.
#'
#' @param population A \code{vector} of values following any population
#'   distribution you wish to simulate.
#' @param sample_size The size of each sample to draw from the population
#' @param theta The \code{function} that computes the statistic of interest
#'   from each sample (e.g., \code{mean} or \code{median}).
#'
#' @usage
#' interactive_sampling()
#'
#' Use the controls in the viewer to draw more samples or change simulation
#' parameters. Click "Done" to return results to the console.
#'
#' @examples
#' \dontrun{
#' interactive_sampling(rnorm(100000))
#'
#' interactive_sampling(c(rnorm(100000, mean = 4), rnorm(100000, mean=-4)),
#'                      theta = median)
#' }
#' @export
interactive_sampling <- function(population, sample_size = 10, theta = mean) {
  ui <- miniUI::miniPage(
    miniUI::gadgetTitleBar("Sampling Distribution",
      right = miniUI::miniTitleBarButton("done", "Done", primary = TRUE)
    ),
    miniUI::miniContentPanel(
      padding = 0,
      shiny::tags$div(
        style = paste("display: flex; flex-direction: column;",
                      "height: 100%;"),
        shiny::tags$div(
          style = paste("display: flex; align-items: flex-end;",
                        "gap: 12px; padding: 8px;",
                        "flex-shrink: 0;"),
          shiny::selectInput("sample_size", "Sample size",
            choices = c(10, 100, 500, 1000, 5000, 10000),
            selected = sample_size, width = "120px"),
          shiny::selectInput("reps", "Repetitions",
            choices = c(1, 5, 10, 50, 100),
            selected = 1, width = "100px"),
          shiny::tags$div(
            style = "margin-bottom: 15px;",
            shiny::actionButton("run", "Sample")
          )
        ),
        shiny::tags$div(
          style = "flex: 1; min-height: 0;",
          shiny::plotOutput("sampling_plot",
                           height = "100%")
        )
      )
    )
  )

  server <- function(input, output, session) {
    cache <- shiny::reactiveVal(NULL)
    trigger <- shiny::reactiveVal(0)

    shiny::observeEvent(input$run, {
      trigger(shiny::isolate(trigger()) + 1)
    })

    output$sampling_plot <- shiny::renderPlot({
      trigger()
      result <- plot_sampling(
        population,
        as.numeric(shiny::isolate(input$sample_size)),
        theta,
        as.numeric(shiny::isolate(input$reps)),
        vars = shiny::isolate(cache()),
        replot_population = FALSE
      )
      cache(result)
    })

    shiny::observeEvent(input$done, {
      shiny::stopApp(cache())
    })

    shiny::observeEvent(input$cancel, {
      shiny::stopApp(NULL)
    })
  }

  old_opts <- options(shiny.quiet = TRUE)
  on.exit(options(old_opts))
  suppressMessages(
    shiny::runGadget(ui, server, viewer = shiny::paneViewer())
  )
}
