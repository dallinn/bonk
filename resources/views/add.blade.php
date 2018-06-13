<!DOCTYPE html>
<html lang="en">
<head>
    @include('partials._head', [ 'title' => 'Dev Test Add' ])
</head>

<body>

@include('partials._nav')

<div class="container">
    @yield('content')

    @if ($errors->any())
        <div class="alert alert-danger">
            <ul>
                @foreach ($errors->all() as $error)
                <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
    @endif

    <form id="postForm" action="/addPost" method="post">
        <input type="hidden" name="_token" value="{{ csrf_token() }}">
        <div class="form-group">
            <input placeholder="Enter title here" type="text" id="title" name="title" class="form-control" required />
        </div>
        <div class="form-group">
            <textarea name="body" id="body" class="form-control" required></textarea>
        </div>
        <input type="submit" class="btn btn-default" value="Submit" />
    </form>
    @include('partials._footer')

</div> <!-- end of .container -->

@include('partials._javascript')
<script type="application/javascript">
$(document).ready(function(){
    $('#postForm').on('submit', function(e){
        e.preventDefault();

        var title = $('#title').val();
        var body = $('#body').val();

        if (title.length < 5 || body.length < 5) {
            alert('Title and Body require at least 5 characters');
        } else {
            //this.submit();
            $.post('/api/addPost', {
                title: title,
                body: body
            }).done(function(data) {
                alert('Post Created');
                $('#postForm').trigger("reset");
            });
        }
    });
});
</script>

@yield('scripts')

</body>
</html>
