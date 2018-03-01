using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class AnalogGlitch : MonoBehaviour
{
    #region Public Properties
    [Header("Scan Line Jitter")]
    [SerializeField, Range(0, 1)]
    float _scanLineJitter = 0;
    public float scanLineJitter
    {
        get { return _scanLineJitter; }
        set { _scanLineJitter = value; }
    }
    [Header("Vertical Jump")]
    [SerializeField, Range(0, 1)]
    float _verticalJump = 0;
    public float verticalJump
    {
        get { return _verticalJump; }
        set { _verticalJump = value; }
    }
    [Header("Horizontal Shake")]
    [SerializeField, Range(0, 1)]
    float _horizontalShake = 0;
    public float horizontalShake
    {
        get { return _horizontalShake; }
        set { _horizontalShake = value; }
    }
    [Header("Colour Drift")]
    [SerializeField, Range(0, 1)]
    float _colourDrift = 0;
    public float colourDrift
    {
        get { return _colourDrift; }
        set { _colourDrift = value; }
    }
    #endregion

    #region Private Properties
    [SerializeField]
    public Shader _shader;
    Material _material;
    float _verticalJumpTime;
    #endregion

    #region MonoBehaviour Functions
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (_material == null)
        {
            _material = new Material(_shader);
            _material.hideFlags = HideFlags.DontSave;
        }

        _verticalJumpTime += Time.deltaTime * _verticalJump * 11.3f;

        var sl_thresh = Mathf.Clamp01(1.0f - _scanLineJitter * 1.2f);
        var sl_disp = 0.002f + Mathf.Pow(_scanLineJitter, 3) * 0.05f;
        _material.SetVector("_ScanLineJitter", new Vector2(sl_disp, sl_thresh));

        var vj = new Vector2(_verticalJump, _verticalJumpTime);
        _material.SetVector("_VerticalJump", vj);

        _material.SetFloat("_HorizontalShake", _horizontalShake * 0.2f);

        var cd = new Vector2(_colourDrift * 0.04f, Time.time * 606.11f);
        _material.SetVector("_ColorDrift", cd);

        Graphics.Blit(source, destination, _material);
    }
    #endregion

}
